defmodule SlackishPhoenixWeb.HomeControllerTest do
  use SlackishPhoenixWeb.ConnCase, async: true

  alias SlackishPhoenixWeb.Router.Helpers

  defp user_fixture(attrs \\ %{}) do
    user = %SlackishPhoenix.Auth.User{
      email: "some email",
      google_id: "some google_id",
      image_url: "some image_url",
      name: "some name",
      current_company_id: nil
    }

    user |> Map.merge(attrs)
  end

  test "GET /home", %{conn: conn} do
    conn = get(conn, "/home")
    assert redirected_to(conn) == "/"
  end

  test "GET /home requires company", %{conn: conn} do
    user = user_fixture()
    conn = conn |> assign(:user, user) |> get("/home")
    assert redirected_to(conn) == Helpers.company_path(conn, :new)
  end

  test "GET /home authenticated with company works", %{conn: conn} do
    user = user_fixture(%{current_company_id: 123})
    conn = conn |> assign(:user, user) |> get("/home")
    assert conn.status != 302
  end
end
