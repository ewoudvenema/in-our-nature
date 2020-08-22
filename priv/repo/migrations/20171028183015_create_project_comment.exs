defmodule Cocu.Repo.Migrations.CreateProjectComment do
  use Ecto.Migration

  def change do
    create table(:project_comment) do
      add :user_id, references(:user, on_delete: :nothing)
      add :project_id, references(:project, on_delete: :nothing)
      add :post_id, references(:post, on_delete: :nothing)

      timestamps()
    end

    create index(:project_comment, [:user_id])
    create index(:project_comment, [:project_id])
    create index(:project_comment, [:post_id])
  end
end
