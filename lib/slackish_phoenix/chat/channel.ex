defmodule SlackishPhoenix.Chat.Channel do
  use Ecto.Schema
  import Ecto.Changeset

  @derive {Jason.Encoder, only: [:name, :id, :company_id]}

  schema "channels" do
    field :name, :string

    belongs_to :company, SlackishPhoenix.Companies.Company

    timestamps()
  end

  @doc false
  def changeset(channel, attrs) do
    channel
    |> cast(attrs, [:name, :company_id])
    |> validate_required([:name, :company_id])
  end
end
