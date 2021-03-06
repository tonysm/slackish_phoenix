defmodule SlackishPhoenix.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :name, :string
      add :email, :string
      add :google_id, :string
      add :image_url, :string
      add :current_company_id, :integer

      timestamps()
    end

    create unique_index(:users, [:email])
  end
end
