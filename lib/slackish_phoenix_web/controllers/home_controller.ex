defmodule SlackishPhoenixWeb.HomeController do
  use SlackishPhoenixWeb, :controller

  plug SlackishPhoenixWeb.Plugs.RequireAuth
  plug SlackishPhoenixWeb.Plugs.RequireCompany

  def index(conn, _params) do
    text(conn, "Works")
  end
end
