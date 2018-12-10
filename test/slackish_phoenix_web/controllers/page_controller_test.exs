defmodule SlackishPhoenixWeb.PageControllerTest do
  use SlackishPhoenixWeb.ConnCase

  test "GET /", %{conn: conn} do
    conn = get(conn, "/")
    assert html_response(conn, 200) =~ "Slackish"
  end
end
