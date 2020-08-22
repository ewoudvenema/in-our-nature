defmodule Cocu.Repo.Migrations.CreateNotificationReply do
  use Ecto.Migration

  def change do
    create table(:notification_reply) do
      add :notification_id, references(:notification, on_delete: :nothing)
      add :post_reply_id, references(:post_reply, on_delete: :nothing)

      timestamps()
    end

    create index(:notification_reply, [:notification_id])
    create index(:notification_reply, [:post_reply_id])
  end
end
