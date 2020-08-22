defmodule Cocu.Repo.Migrations.CreateCommunityUser do
  use Ecto.Migration

  def change do
    create table(:community_user) do
      add :user_id, references(:user, on_delete: :nothing)
      add :community_id, references(:community, on_delete: :nothing)

      timestamps()
    end

    create index(:community_user, [:user_id])
    create index(:community_user, [:community_id])
  end
end
