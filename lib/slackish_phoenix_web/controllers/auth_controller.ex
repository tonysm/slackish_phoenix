defmodule SlackishPhoenixWeb.AuthController do
  use SlackishPhoenixWeb, :controller

  plug Ueberauth

  alias SlackishPhoenix.Auth

  def callback(%{assigns: %{ueberauth_failure: _fails}} = conn, _params) do
    conn
    |> put_flash(:error, "Failed to authenticate.")
    |> redirect(to: "/")
  end

  def callback(%{assigns: %{ueberauth_auth: auth}} = conn, _params) do
    case Auth.find_or_create_from_auth(auth) do
      {:ok, user}
        -> conn
          |> put_flash(:info, "Successfully authenticated.")
          |> put_session(:current_user, user.id)
          |> redirect(to: "/home")
      {:error, reason} ->
        conn
        |> put_flash(:error, reason)
        |> redirect(to: "/")
    end
  end
end
