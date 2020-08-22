defmodule Cocu.Repo.Migrations.CreateProjectPost do
  use Ecto.Migration

  def change do
    create table(:project_post) do
      add :user_id, references(:user, on_delete: :nothing)
      add :project_id, references(:project, on_delete: :nothing)
      add :post_id, references(:post, on_delete: :nothing)

      timestamps()
    end

    create index(:project_post, [:user_id])
    create index(:project_post, [:project_id])
    create index(:project_post, [:post_id])
  end
end
