defmodule Cocu.Repo.Migrations.CreateDonation do
  use Ecto.Migration

  def change do
    create table(:donation) do
      add :value, :float
      add :user_id, references(:user, on_delete: :nothing)
      add :project_id, references(:project, on_delete: :nothing)

      timestamps()
    end

    create index(:donation, [:user_id])
    create index(:donation, [:project_id])
  end
end
