defmodule SlackishPhoenix.Repo.Migrations.CreateChannels do
  use Ecto.Migration

  def change do
    create table(:channels) do
      add :name, :string
      add :company_id, :integer

      timestamps()
    end
  end
end
