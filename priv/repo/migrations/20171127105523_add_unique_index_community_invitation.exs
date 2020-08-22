defmodule Cocu.Repo.Migrations.AddUniqueIndexCommunityInvitation do
  use Ecto.Migration

  def change do
    create unique_index("community_invitations", [:inviter_id, :invited_id, :community_id])
  end
end
