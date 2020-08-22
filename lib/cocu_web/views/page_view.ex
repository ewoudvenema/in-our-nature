defmodule CocuWeb.PageView do
  use CocuWeb, :view
  alias Cocu.Projects
  alias Cocu.Communities
  alias Cocu.CommunityUsers

  def get_project_photos(id) do
    Projects.get_project_photos(id)
  end

  def get_communities() do
    Communities.get_most_popular_communities()
  end

  def user_follows_community(user_id, community_id) do
    check_empty = CommunityUsers.user_follows_community(user_id, community_id)
    |> Enum.empty?
    not check_empty
  end

end
