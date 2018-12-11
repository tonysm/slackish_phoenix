defmodule SlackishPhoenixWeb.Plugs.RequireAuthTest do
  use SlackishPhoenixWeb.ConnCase

  test "call/2 redirects back to welcome page when there is no user in session", %{conn: conn} do
    conn = conn |> SlackishPhoenixWeb.Plugs.RequireAuth.call(%{})
    assert redirected_to(conn) == "/"
  end

  test "call/2 works when there is a user id in session", %{conn: conn} do
    conn = conn |> assign(:user, 123) |> SlackishPhoenixWeb.Plugs.RequireAuth.call(%{})
    assert conn.status != 302
  end
end
