defmodule SlackishPhoenixWeb.HomeControllerTest do
  use SlackishPhoenixWeb.ConnCase, async: true

  import SlackishPhoenix.Factory

  alias SlackishPhoenix.Companies

  test "GET /home/:company fails when company does not exist", %{conn: conn} do
    user = insert(:user)

    assert_raise Ecto.NoResultsError, fn ->
      conn |> assign(:user, user) |> get("/home/123")
    end
  end

  test "GET /home/:company authenticated with company works", %{conn: conn} do
    company = insert(:company)
    user = insert(:user, %{current_company_id: company.id})
    Companies.add_user_to_company(user, company)

    conn = conn |> assign(:user, user) |> get("/home/#{company.id}")
    assert conn.status != 302
  end
end
