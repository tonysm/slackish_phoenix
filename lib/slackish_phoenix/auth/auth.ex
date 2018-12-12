defmodule SlackishPhoenix.Auth do
  @moduledoc """
  The Auth context.
  """

  import Ecto.Query, warn: false
  alias SlackishPhoenix.Repo

  alias SlackishPhoenix.Auth.User

  @doc """
  Returns the list of users.

  ## Examples

      iex> list_users()
      [%User{}, ...]

  """
  def list_users do
    Repo.all(User)
  end

  @doc """
  Gets a single user.

  Raises `Ecto.NoResultsError` if the User does not exist.

  ## Examples

      iex> get_user!(123)
      %User{}

      iex> get_user!(456)
      ** (Ecto.NoResultsError)

  """
  def get_user!(id), do: Repo.get!(User, id)

  @doc """
    Finds the user or returns nil.
  """
  def get_user(nil), do: nil
  def get_user(id), do: Repo.get(User, id)

  @doc """
  Creates a user.

  ## Examples

      iex> create_user(%{field: value})
      {:ok, %User{}}

      iex> create_user(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_user(attrs \\ %{}) do
    %User{}
    |> User.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a user.

  ## Examples

      iex> update_user(user, %{field: new_value})
      {:ok, %User{}}

      iex> update_user(user, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_user(%User{} = user, attrs) do
    user
    |> User.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a User.

  ## Examples

      iex> delete_user(user)
      {:ok, %User{}}

      iex> delete_user(user)
      {:error, %Ecto.Changeset{}}

  """
  def delete_user(%User{} = user) do
    Repo.delete(user)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking user changes.

  ## Examples

      iex> change_user(user)
      %Ecto.Changeset{source: %User{}}

  """
  def change_user(%User{} = user) do
    User.changeset(user, %{})
  end

  @doc """
  Finds an existing user by the provider ID or creates one, in case it doesn't exist.
  """
  def find_or_create_from_auth(auth) do
    params = parse_params(auth)

    case get_by_google_id(params.google_id) do
      {:ok, nil} ->
        create_user(params)

      {:ok, %User{} = user} ->
        {:ok, user}

      {:error, _msg} ->
        {:error, "Something went wrong"}
    end
  end

  defp get_by_google_id(google_id) do
    user =
      from(u in User, where: u.google_id == ^google_id)
      |> first
      |> Repo.one()

    {:ok, user}
  end

  defp parse_params(auth) do
    %{
      email: auth.info.email,
      name: build_name(auth),
      image_url: auth.info.image,
      google_id: auth.uid
    }
  end

  defp build_name(auth) do
    "#{auth.info.first_name} #{auth.info.last_name}"
    |> String.trim()
  end
end
