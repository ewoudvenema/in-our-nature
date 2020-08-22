defmodule Cocu.Repo.Migrations.UniqueUserIdCommunityIdCommunityUsers do
  use Ecto.Migration

  def change do
    create unique_index("community_user", [:user_id, :community_id])
  end
end
