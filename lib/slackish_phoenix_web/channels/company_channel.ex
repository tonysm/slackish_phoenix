defmodule SlackishPhoenixWeb.CompanyChannel do
  use SlackishPhoenixWeb, :channel

  alias SlackishPhoenix.Auth
  alias SlackishPhoenix.Companies
  alias SlackishPhoenix.Chat

  def join("company:" <> company_id, _payload, socket) do
    user_id = socket.assigns[:user_id]
    company_id = company_id |> String.to_integer()

    user = user_id |> Auth.get_user!()
    company = company_id |> Companies.get_company!()
    channels = company_id |> Chat.list_channels_of_company()

    {:ok, %{company: company, user: user, channels: channels},
     assign(socket, :company_id, company_id)}
  end

  def handle_in(_name, %{"channel" => name}, socket) do
    company_id = socket.assigns[:company_id]

    params = %{
      name: name,
      company_id: company_id
    }

    IO.inspect(params)

    case Chat.create_channel(params) do
      {:ok, channel} ->
        IO.inspect(channel)

        broadcast!(socket, "company:#{company_id}:new", %{
          channel: channel
        })

        {:reply, :ok, socket}

      {:error, reason} ->
        IO.inspect(reason)
        {:reply, :error, socket}
    end
  end
end
