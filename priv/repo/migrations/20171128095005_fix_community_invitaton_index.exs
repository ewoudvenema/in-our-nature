defmodule Cocu.Repo.Migrations.FixCommunityInvitatonIndex do
  use Ecto.Migration

  def change do
    drop_if_exists index("community_invitations_inviter_id_invited_id_community_id",[:inviter_id, :invited_id, :community_id])
    create unique_index("community_invitations", [:invited_id, :community_id])
  end
end
