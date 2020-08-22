defmodule Cocu.Repo.Migrations.CreateCommunityPost do
  use Ecto.Migration

  def change do
    create table(:community_post) do
      add :user_id, references(:user, on_delete: :nothing)
      add :community_id, references(:community, on_delete: :nothing)
      add :post_id, references(:post, on_delete: :nothing)

      timestamps()
    end

    create index(:community_post, [:user_id])
    create index(:community_post, [:community_id])
    create index(:community_post, [:post_id])
  end
end
