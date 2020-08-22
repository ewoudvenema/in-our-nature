defmodule Cocu.Repo.Migrations.UpdateCommunityDelete do
  use Ecto.Migration

  def change do
    drop constraint("community_invitations", "community_invitations_community_id_fkey")
    alter table(:community_invitations) do
      modify :community_id, references(:community, on_delete: :delete_all)
    end

    drop constraint("community_post", "community_post_community_id_fkey")
    alter table(:community_post) do
      modify :community_id, references(:community, on_delete: :delete_all)
    end

    drop constraint("community_project", "community_project_community_id_fkey")
    alter table(:community_project) do
      modify :community_id, references(:community, on_delete: :delete_all)
    end

    drop constraint("community_user", "community_user_community_id_fkey")
    alter table(:community_user) do
      modify :community_id, references(:community, on_delete: :delete_all)
    end

    drop constraint("project", "project_community_id_fkey")
    alter table(:project) do
      modify :community_id, references(:community, on_delete: :nilify_all)
    end
  end
end
