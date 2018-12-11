defmodule SlackishPhoenixWeb.Plugs.RequireAuth do
  import Plug.Conn
  import Phoenix.Controller

  alias SlackishPhoenixWeb.Router.Helpers

  def init(_params) do
  end

  def call(conn, _params) do
    if conn.assigns[:user] do
      conn
    else
      conn
      |> redirect(to: Helpers.page_path(conn, :index))
      |> halt()
    end
  end
end
