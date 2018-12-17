defmodule SlackishPhoenixWeb.CompanyChannel do
  use SlackishPhoenixWeb, :channel

  alias SlackishPhoenix.Auth
  alias SlackishPhoenix.Companies
  alias SlackishPhoenix.Chat

  def join("company:" <> company_id, _payload, socket) do
    user_id = socket.assigns[:user_id]

    user = user_id |> Auth.get_user!()
    company = company_id |> Companies.get_company!()

    {:ok, %{company: company, user: user}, assign(socket, :company_id, company_id)}
  end

  def handle_in(_name, %{"channel" => name}, socket) do
    company_id = socket.assigns[:company_id]

    params = %{
      name: name,
      company_id: company_id
    }

    case Chat.create_channel(params) do
      {:ok, channel} ->
        broadcast!(socket, "companies:#{company_id}:new", %{
          channel: channel
        })

        {:reploy, :ok, socket}

      {:error, _reason} ->
        {:reploy, :error, socket}
    end
  end
end
