defmodule CocuWeb.UserView do
  use CocuWeb, :view
  
  alias Cocu.Projects
  alias Cocu.Communities
  alias Cocu.CommunityUsers
  alias Cocu.CommunityInvitations

  def get_projects_by_user_id(id) do
    Projects.get_projects_by_user(id)
  end

  def get_communities_by_user_id(id) do
    Communities.get_communities_by_user(id)
  end

  def get_followed_communities(id) do
    CommunityUsers.get_followed_communities(id)
  end

  def get_project_photos(id) do
    Projects.get_project_photos(id)
  end

  def get_community_name(id) do
    Communities.get_community_name(id)
  end

  def get_community_photo(id) do
    Communities.get_community_photo(id)
  end

  @doc """
  Returns a list of maps with:
  Id and name of the community the user was invited to
  Name and picture (path) of the user that invited the current user to the community
  """
  def get_community_invitations(id) do
    CommunityInvitations.get_by_invitee_id(id)
  end
end
