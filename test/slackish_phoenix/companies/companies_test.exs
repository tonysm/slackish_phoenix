defmodule SlackishPhoenix.CompaniesTest do
  use SlackishPhoenix.DataCase

  alias SlackishPhoenix.Companies
  alias SlackishPhoenix.Companies.Company

  import SlackishPhoenix.Factory

  describe "companies" do
    alias SlackishPhoenix.Companies.Company

    @update_attrs %{name: "some updated name", owner_id: 43}
    @invalid_attrs %{name: nil, owner_id: nil}

    test "list_companies/0 returns all companies" do
      company = insert(:company)
      assert Companies.list_companies() == [company]
    end

    test "get_company!/1 returns the company with given id" do
      company = insert(:company)
      assert Companies.get_company!(company.id) == company
    end

    test "create_company/1 with valid data creates a company" do
      assert {:ok, %Company{} = company} =
               Companies.create_company(%{
                 name: "some name",
                 owner_id: 42
               })

      assert company.name == "some name"
      assert company.owner_id == 42
    end

    test "create_company/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Companies.create_company(@invalid_attrs)
    end

    test "update_company/2 with valid data updates the company" do
      company = insert(:company)
      assert {:ok, %Company{} = company} = Companies.update_company(company, @update_attrs)
      assert company.name == "some updated name"
      assert company.owner_id == 43
    end

    test "update_company/2 with invalid data returns error changeset" do
      company = insert(:company)
      assert {:error, %Ecto.Changeset{}} = Companies.update_company(company, @invalid_attrs)
      assert company == Companies.get_company!(company.id)
    end

    test "delete_company/1 deletes the company" do
      company = insert(:company)
      assert {:ok, %Company{}} = Companies.delete_company(company)
      assert_raise Ecto.NoResultsError, fn -> Companies.get_company!(company.id) end
    end

    test "change_company/1 returns a company changeset" do
      company = insert(:company)
      assert %Ecto.Changeset{} = Companies.change_company(company)
    end

    test "add_user_to_company/2 associates a user with a company" do
      company = insert(:company)
      user = insert(:user)

      assert {:ok} = Companies.add_user_to_company(user, company)
      assert [company] == Companies.list_all_companies_of_user(user)
      assert [user] == Companies.list_all_users_of_company(company)
    end

    test "get_company_of_user!/2 returns the company fetching from a user association" do
      company = insert(:company)
      user = insert(:user)

      Companies.add_user_to_company(user, company)

      assert %Company{} = found_company = Companies.get_company_for_user!(user, company.id)
      assert found_company.id == company.id
    end
  end
end
