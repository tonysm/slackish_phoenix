defmodule SlackishPhoenixWeb.CompanyChannel do
  use SlackishPhoenixWeb, :channel

  alias SlackishPhoenix.Auth
  alias SlackishPhoenix.Companies

  def join("company:" <> company_id, _payload, socket) do
    user_id = socket.assigns[:user_id]

    user = user_id |> Auth.get_user!()
    company = company_id |> Companies.get_company!()

    {:ok, %{company: company, user: user}, assign(socket, :company_id, company_id)}
  end
end
