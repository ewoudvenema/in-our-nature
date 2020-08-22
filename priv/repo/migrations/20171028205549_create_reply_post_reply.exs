defmodule Cocu.Repo.Migrations.CreateReplyPostReply do
  use Ecto.Migration

  def change do
    create table(:reply_post_reply) do
      add :parent_post_reply_id, references(:post, on_delete: :nothing)
      add :child_post_reply_id, references(:post, on_delete: :nothing)

      timestamps()
    end

    create index(:reply_post_reply, [:parent_post_reply_id])
    create index(:reply_post_reply, [:child_post_reply_id])
  end
end
