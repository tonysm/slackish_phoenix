defmodule SlackishPhoenixWeb.HomeController do
  use SlackishPhoenixWeb, :controller

  plug SlackishPhoenixWeb.Plugs.RequireAuth
  plug SlackishPhoenixWeb.Plugs.RequireCompany

  alias SlackishPhoenixWeb.Auth.UserTokenManager

  def index(conn, _params) do
    {:ok, token} = UserTokenManager.issue_token(conn.assigns[:user])

    render(conn, "index.html", token: token)
  end
end
