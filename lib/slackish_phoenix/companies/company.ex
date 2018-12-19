defmodule SlackishPhoenix.Companies.Company do
  use Ecto.Schema
  import Ecto.Changeset

  @derive {Jason.Encoder, only: [:name, :id]}

  schema "companies" do
    field :name, :string

    belongs_to :owner, SlackishPhoenix.Auth.User

    timestamps()
  end

  @doc false
  def changeset(company, attrs) do
    company
    |> cast(attrs, [:name, :owner_id])
    |> validate_required([:name, :owner_id])
  end
end
