defmodule Cocu.Repo.Migrations.CreateCommunityProject do
  use Ecto.Migration

  def change do
    create table(:community_project) do
      add :project_id, references(:project, on_delete: :nothing)
      add :community_id, references(:community, on_delete: :nothing)

      timestamps()
    end

    create index(:community_project, [:project_id])
    create index(:community_project, [:community_id])
  end
end
