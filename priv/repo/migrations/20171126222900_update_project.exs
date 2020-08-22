defmodule Cocu.Repo.Migrations.UpdateProject do
  use Ecto.Migration

  def change do
    alter table(:project) do
      add :community_id, references(:community, on_delete: :nothing)
    end

    create index(:project, [:community_id])
  end
end
