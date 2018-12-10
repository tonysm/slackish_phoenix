defmodule SlackishPhoenix.Auth.User do
  use Ecto.Schema
  import Ecto.Changeset


  schema "users" do
    field :email, :string
    field :google_id, :string
    field :image_url, :string
    field :name, :string

    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:name, :email, :google_id, :image_url])
    |> validate_required([:name, :email, :google_id, :image_url])
    |> unique_constraint(:email)
  end
end
