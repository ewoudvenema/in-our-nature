defmodule Cocu.Repo.Migrations.CreatePostReply do
  use Ecto.Migration

  def change do
    create table(:post_reply) do
      add :content, :string, null: false
      add :user_id, references(:user, on_delete: :nothing)
      add :post_id, references(:post, on_delete: :nothing)

      timestamps()
    end

    create index(:post_reply, [:user_id])
    create index(:post_reply, [:post_id])
  end
end
