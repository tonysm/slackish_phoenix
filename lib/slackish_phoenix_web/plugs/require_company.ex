defmodule SlackishPhoenixWeb.Plugs.RequireCompany do
  import Plug.Conn
  import Phoenix.Controller

  alias SlackishPhoenixWeb.Router.Helpers

  def init(_params) do
  end

  def call(conn, _params) do
    case conn.assigns[:user] do
      nil
        -> conn |> redirect_and_halt(Helpers.home_path(conn, :index))
      user
        -> conn
          |> validate_has_company(user)
    end
  end

  defp validate_has_company(conn, user) do
    case user.current_company_id do
      nil
        -> conn |> redirect_and_halt(Helpers.company_path(conn, :new))
      _id
        -> conn
    end
  end

  defp redirect_and_halt(conn, path) do
    conn
      |> redirect(to: path)
      |> halt()
  end
end
