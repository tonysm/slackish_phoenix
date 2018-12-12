defmodule SlackishPhoenix.Companies.Company do
  use Ecto.Schema
  import Ecto.Changeset

  schema "companies" do
    field :name, :string
    field :owner_id, :integer

    timestamps()
  end

  @doc false
  def changeset(company, attrs) do
    company
    |> cast(attrs, [:name, :owner_id])
    |> validate_required([:name, :owner_id])
  end
end