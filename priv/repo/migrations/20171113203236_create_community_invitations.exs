defmodule Cocu.Repo.Migrations.CreateCommunityInvitations do
  use Ecto.Migration

  def change do
    create table(:community_invitations) do
      add :inviter_id, references(:user, on_delete: :nothing)
      add :invited_id, references(:user, on_delete: :nothing)
      add :community_id, references(:community, on_delete: :nothing)

      timestamps()
    end

    create index(:community_invitations, [:inviter_id])
    create index(:community_invitations, [:invited_id])
    create index(:community_invitations, [:community_id])
  end
end
