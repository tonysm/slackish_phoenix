defmodule SlackishPhoenixWeb.CompanyController do
  use SlackishPhoenixWeb, :controller

  plug SlackishPhoenixWeb.Plugs.RequireAuth

  alias SlackishPhoenix.Companies
  alias SlackishPhoenix.Auth
  alias SlackishPhoenix.Companies.Company

  def new(conn, _params) do
    companies = Companies.list_all_companies_of_user(conn.assigns[:user])
    changeset = Company.changeset(%Company{}, %{})

    render(conn, "new.html", changeset: changeset, companies: companies)
  end

  def create(conn, %{"company" => params}) do
    user = conn.assigns[:user]

    case Companies.create_company(params |> Map.put("owner_id", user.id)) do
      {:ok, company} ->
        Auth.assign_current_company(user, company.id)
        Companies.add_user_to_company(user, company)
        conn |> redirect(to: "/home/#{company.id}")

      {:error, changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end
end
