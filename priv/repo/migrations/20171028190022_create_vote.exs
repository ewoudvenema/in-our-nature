defmodule Cocu.Repo.Migrations.CreateVote do
  use Ecto.Migration

  def change do
    create table(:vote) do
      add :positive, :boolean, default: false, null: false
      add :user_id, references(:user, on_delete: :nothing)
      add :project_id, references(:project, on_delete: :nothing)

      timestamps()
    end

    create index(:vote, [:user_id])
    create index(:vote, [:project_id])
  end
end
