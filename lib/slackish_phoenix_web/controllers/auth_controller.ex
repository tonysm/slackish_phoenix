defmodule SlackishPhoenixWeb.AuthController do
  require Logger
  use SlackishPhoenixWeb, :controller
  plug Ueberauth

  def callback(%{assigns: %{ueberauth_failure: _fails}} = conn, _params) do
    conn
    |> put_flash(:error, "Failed to authenticate.")
    |> redirect(to: "/")
  end

  def callback(%{assigns: %{ueberauth_auth: auth}} = conn, _params) do
    Logger.info "Auth: #{inspect(auth)}"
    text conn, "OK"
  end
end
