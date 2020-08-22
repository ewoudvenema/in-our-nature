defmodule Cocu.Repo.Migrations.CreateNotificationComment do
  use Ecto.Migration

  def change do
    create table(:notification_comment) do
      add :notification_id, references(:notification, on_delete: :nothing)
      add :project_comment_id, references(:project_comment, on_delete: :nothing)

      timestamps()
    end

    create index(:notification_comment, [:notification_id])
    create index(:notification_comment, [:project_comment_id])
  end
end
