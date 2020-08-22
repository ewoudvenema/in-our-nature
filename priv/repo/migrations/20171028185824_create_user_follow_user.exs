defmodule Cocu.Repo.Migrations.CreateUserFollowUser do
  use Ecto.Migration

  def change do
    create table(:user_follow_user) do
      add :followed_user_id, references(:user, on_delete: :nothing)
      add :follower_user_id, references(:user, on_delete: :nothing)

      timestamps()
    end

    create index(:user_follow_user, [:followed_user_id])
    create index(:user_follow_user, [:follower_user_id])
  end
end
