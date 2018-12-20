defmodule SlackishPhoenix.Companies.Company do
  use Ecto.Schema
  import Ecto.Changeset

  @derive {Jason.Encoder, only: [:name, :id]}

  schema "companies" do
    field :name, :string

    belongs_to :owner, SlackishPhoenix.Auth.User
    many_to_many :users, SlackishPhoenix.Auth.User, join_through: "company_user"

    timestamps()
  end

  @doc false
  def changeset(company, attrs) do
    company
    |> cast(attrs, [:name, :owner_id])
    |> validate_required([:name, :owner_id])
  end
end
