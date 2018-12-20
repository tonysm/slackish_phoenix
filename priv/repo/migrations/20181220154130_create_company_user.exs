defmodule SlackishPhoenix.Repo.Migrations.CreateCompanyUser do
  use Ecto.Migration

  def change do
    create table(:company_user) do
      add :company_id, references(:companies)
      add :user_id, references(:users)
    end
  end
end
