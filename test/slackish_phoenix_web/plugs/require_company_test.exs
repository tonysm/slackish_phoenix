defmodule SlackishPhoenixWeb.Plugs.RequireCompanyTest do
  use SlackishPhoenixWeb.ConnCase, async: true

  alias SlackishPhoenix.Auth.User
  alias SlackishPhoenixWeb.Router.Helpers

  test "call/2 redirects to company form when current user has no company", %{conn: conn} do
    user = %User{current_company_id: 123}
    conn = conn |> assign(:user, user) |> SlackishPhoenixWeb.Plugs.RequireCompany.call(%{})
    assert conn.status !== 302
  end

  test "call/2 allows connection to pass when current user has company", %{conn: conn} do
    user = %User{current_company_id: nil}
    conn = conn |> assign(:user, user) |> SlackishPhoenixWeb.Plugs.RequireCompany.call(%{})
    assert redirected_to(conn) == Helpers.company_path(conn, :new)
  end

  test "call/2 redirects to home_page when there is no authenticated user", %{conn: conn} do
    conn = conn |> SlackishPhoenixWeb.Plugs.RequireCompany.call(%{})

    assert redirected_to(conn) == Helpers.home_path(conn, :index)
  end
end
