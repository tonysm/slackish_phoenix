defmodule SlackishPhoenix.Companies do
  @moduledoc """
  The Companies context.
  """

  import Ecto.Query, warn: false
  alias SlackishPhoenix.Repo

  alias SlackishPhoenix.Auth.User
  alias SlackishPhoenix.Companies.Company

  @doc """
  Returns the list of companies.

  ## Examples

      iex> list_companies()
      [%Company{}, ...]

  """
  def list_companies do
    Repo.all(Company)
  end

  @doc """
  Gets a single company.

  Raises `Ecto.NoResultsError` if the Company does not exist.

  ## Examples

      iex> get_company!(123)
      %Company{}

      iex> get_company!(456)
      ** (Ecto.NoResultsError)

  """
  def get_company!(id), do: Repo.get!(Company, id)

  @doc """
  Creates a company.

  ## Examples

      iex> create_company(%{field: value})
      {:ok, %Company{}}

      iex> create_company(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_company(attrs \\ %{}) do
    %Company{}
    |> Company.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a company.

  ## Examples

      iex> update_company(company, %{field: new_value})
      {:ok, %Company{}}

      iex> update_company(company, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_company(%Company{} = company, attrs) do
    company
    |> Company.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Company.

  ## Examples

      iex> delete_company(company)
      {:ok, %Company{}}

      iex> delete_company(company)
      {:error, %Ecto.Changeset{}}

  """
  def delete_company(%Company{} = company) do
    Repo.delete(company)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking company changes.

  ## Examples

      iex> change_company(company)
      %Ecto.Changeset{source: %Company{}}

  """
  def change_company(%Company{} = company) do
    Company.changeset(company, %{})
  end

  @doc """
  Associates an `%SlackishPhoenix.Auth.User` with a `%SlackishPhoenix.Companies.Company`.
  """
  def add_user_to_company(
        %SlackishPhoenix.Auth.User{} = user,
        %SlackishPhoenix.Companies.Company{} = company
      ) do
    user = user |> Repo.preload(:companies)
    companies = (user.companies ++ [company]) |> Enum.map(&Ecto.Changeset.change/1)

    user
    |> Ecto.Changeset.change()
    |> Ecto.Changeset.put_assoc(:companies, companies)
    |> Repo.update!()

    {:ok}
  end

  @doc false
  def list_all_companies_of_user(%User{} = user) do
    user = user |> Repo.preload(:companies)

    user.companies
  end

  @doc false
  def list_all_users_of_company(%Company{} = company) do
    company = company |> Repo.preload(:users)

    company.users
  end

  @doc false
  def get_company_for_user!(%User{} = user, company_id) do
    build_company_for_user_query(user, company_id)
    |> Repo.one!()
  end

  @doc false
  def get_company_for_user(%User{} = user, company_id) do
    build_company_for_user_query(user, company_id)
    |> Repo.one()
  end

  defp build_company_for_user_query(%User{} = user, company_id) do
    query =
      from c in Company,
        join: u in "company_user",
        on: u.company_id == c.id,
        where: u.user_id == ^user.id,
        where: c.id == ^company_id,
        select: c

    query |> first
  end
end
