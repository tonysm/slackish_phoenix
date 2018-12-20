defmodule SlackishPhoenixWeb.CompanyChannel do
  use SlackishPhoenixWeb, :channel

  alias SlackishPhoenix.Auth
  alias SlackishPhoenix.Companies
  alias SlackishPhoenix.Chat

  alias SlackishPhoenixWeb.Presence

  def join("company:" <> company_id, _payload, socket) do
    user_id = socket.assigns[:user_id]
    company_id = company_id |> String.to_integer()

    user = user_id |> Auth.get_user!()

    case Companies.get_company_for_user(user, company_id) do
      %SlackishPhoenix.Companies.Company{} = company ->
        channels = company_id |> Chat.list_channels_of_company()

        send(self(), :after_join)

        {:ok, %{company: company, user: user, channels: channels},
         assign(socket, :company_id, company_id)}

      nil ->
        {:error, reason: "You are not a member of this company."}
    end
  end

  def handle_info(:after_join, socket) do
    push(socket, "presence_state", Presence.list(socket))
    user_id = socket.assigns.user_id

    user = user_id |> Auth.get_user!()

    {:ok, _} =
      Presence.track(socket, user_id, %{
        user: user,
        online_at: inspect(System.system_time(:second))
      })

    {:noreply, socket}
  end

  def handle_in(_name, %{"channel" => name}, socket) do
    company_id = socket.assigns[:company_id]

    params = %{
      name: name,
      company_id: company_id
    }

    case Chat.create_channel(params) do
      {:ok, channel} ->
        broadcast!(socket, "company:#{company_id}:new", %{
          channel: channel
        })

        {:reply, :ok, socket}

      {:error, _reason} ->
        {:reply, :error, socket}
    end
  end
end
