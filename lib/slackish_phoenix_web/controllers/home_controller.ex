defmodule SlackishPhoenixWeb.HomeController do
  use SlackishPhoenixWeb, :controller

  plug SlackishPhoenixWeb.Plugs.RequireAuth

  alias SlackishPhoenixWeb.Auth.UserTokenManager
  alias SlackishPhoenix.Companies

  def index(conn, %{"company" => company_id}) do
    company = Companies.get_company_for_user!(conn.assigns[:user], company_id)

    {:ok, token} = UserTokenManager.issue_token(conn.assigns[:user])

    render(conn, "index.html", token: token, company: company)
  end
end
