defmodule SlackishPhoenix.Auth.User do
  use Ecto.Schema
  import Ecto.Changeset

  @derive {Jason.Encoder, only: [:name, :id, :image_url]}

  schema "users" do
    field :email, :string
    field :google_id, :string
    field :image_url, :string
    field :name, :string
    field :current_company_id, :integer

    many_to_many :companies, SlackishPhoenix.Companies.Company, join_through: "company_user"

    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:name, :email, :google_id, :image_url, :current_company_id])
    |> validate_required([:name, :email, :google_id, :image_url])
    |> unique_constraint(:email)
  end
end
