defmodule CocuWeb.CommunityView do
  use CocuWeb, :view

  alias Cocu.CommunityUsers

  def user_photo do
    "/images/default-user.png"
  end

  def user_follows_community(user_id, community_id) do
    check_empty = CommunityUsers.user_follows_community(user_id, community_id)
    |> Enum.empty?
    not check_empty
  end

  def user_is_founder(user_id, community_id) do
    if [user_id] == [Cocu.Communities.get_founder(community_id)] do
      true
    else
      false
    end
  end

  def num_followers(community_id) do
    [num_followers] = CommunityUsers.get_num_followers(community_id)
    num_followers
  end

  def get_project_photo(project_id) do
    pictures = Cocu.Medias.get_media_by_project(project_id)
    case pictures do
      [] -> "/images/universe_mask.jpg"
      [project_photo | _tail] -> project_photo[:image_path]  
    end
  end
end
