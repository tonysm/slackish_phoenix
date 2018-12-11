defmodule SlackishPhoenixWeb.HomeControllerTest do
  use SlackishPhoenixWeb.ConnCase

  @valid_attrs %{email: "some email", google_id: "some google_id", image_url: "some image_url", name: "some name"}

  def user_fixture(attrs \\ %{}) do
    {:ok, user} =
      attrs
      |> Enum.into(@valid_attrs)
      |> SlackishPhoenix.Auth.create_user()

    user
  end

  test "GET /home", %{conn: conn} do
    conn = get(conn, "/home")
    assert redirected_to(conn) == "/"
  end

  test "GET /home but authenticated", %{conn: conn} do
    user = user_fixture()

    conn = conn |> Plug.Test.init_test_session(current_user: user.id) |> get("/home")
    assert conn.status != 302
  end
end
