defmodule SlackishPhoenixWeb.HomeControllerTest do
  use SlackishPhoenixWeb.ConnCase, async: true

  alias SlackishPhoenixWeb.Router.Helpers

  import SlackishPhoenix.Factory

  test "GET /home", %{conn: conn} do
    conn = get(conn, "/home")
    assert redirected_to(conn) == "/"
  end

  test "GET /home requires company", %{conn: conn} do
    user = insert(:user)
    conn = conn |> assign(:user, user) |> get("/home")
    assert redirected_to(conn) == Helpers.company_path(conn, :new)
  end

  test "GET /home authenticated with company works", %{conn: conn} do
    user = insert(:user, %{current_company_id: 123})
    conn = conn |> assign(:user, user) |> get("/home")
    assert conn.status != 302
  end
end
