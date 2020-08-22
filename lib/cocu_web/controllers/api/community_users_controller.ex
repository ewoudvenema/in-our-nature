defmodule CocuWeb.V1.CommunityUsersController do

    use CocuWeb, :controller

    alias Cocu.CommunityUsers
    alias Cocu.CommunityInvitations
    alias Cocu.Communities

  def get_available_communities(conn, params) do
    user_id = Guardian.Plug.current_resource(conn).id
    name = params["name"]
    communities = CommunityUsers.get_available_communities(user_id, name)
    json(conn, %{success: "true", results: communities})
  end

  def user_follows_community(user_id, community_id) do
    check_empty = user_id
    |> CommunityUsers.user_follows_community(community_id)
    |> Enum.empty?
    not check_empty
  end

  def follow_community(user_id, community_id) do
    %{"user_id" => user_id, "community_id" => String.to_integer community_id}
    |> CommunityUsers.create_community_user
  end

  def unfollow_community(user_id, community_id) do
    user_id
    |> CommunityUsers.delete_community_user_pair(community_id)
  end

  def toggle_follow(conn, %{"community_id" => community_id}) do
    user_id = Guardian.Plug.current_resource(conn).id
    if user_follows_community(user_id, community_id) do
      unfollow_community(user_id, community_id)
      json(conn, %{success: true, follows: false, id: community_id, csrf: Plug.CSRFProtection.get_csrf_token()})
    else
      if not Communities.is_private(community_id) do
        follow_community(user_id, community_id)
        json(conn, %{success: true, follows: true, id: community_id, csrf: Plug.CSRFProtection.get_csrf_token()})
      else
        accept_invitation(conn, %{"community_id" => community_id})
      end
    end
  end

  def has_invites(user_id, community_id) do
    not Enum.empty? CommunityInvitations.get_invite(user_id, community_id)
  end

  def remove_invites(user_id, community_id) do
    CommunityInvitations.remove_invitation(user_id, community_id)
  end

  def accept_invitation(conn, %{"community_id" => community_id}) do
    user_id = Guardian.Plug.current_resource(conn).id
    if has_invites(user_id, community_id) do
      follow_community(user_id, community_id)
      remove_invites(user_id, community_id)
      json(conn, %{success: true, follows: true, csrf: Plug.CSRFProtection.get_csrf_token()})
    else
      json(conn, %{success: false, follows: false, message: "You do not have an invitation for this community", csrf: Plug.CSRFProtection.get_csrf_token()})
    end
  end

  def reject_invitation(conn, %{"community_id" => community_id}) do
    user_id = Guardian.Plug.current_resource(conn).id
    if has_invites(user_id, community_id) do
      remove_invites(user_id, community_id)
    end
      json(conn, %{success: true, follows: false, csrf: Plug.CSRFProtection.get_csrf_token()})
  end

  def get_followers(conn, %{"community_id" => community_id, "page" => page}) do
    founder = Communities.get_founder(community_id) 
    user_id = Guardian.Plug.current_resource(conn).id
    is_founder = 
    case founder == user_id do
      true -> true
      _ -> false
    end
    offset = String.to_integer(page) * 10
    users = CommunityUsers.get_n_users(community_id, 10, offset)
    users = Enum.map(users, fn (user) -> 
      case user[:photo] do
        nil -> user = Map.put(user, :photo, "/images/default-user.png")
          user
        _ -> user
      end
    end
    )
    json(conn, %{users: users, is_founder: is_founder, csrf: Plug.CSRFProtection.get_csrf_token()})
  end

  def remove_user(conn, %{"community_id" => community_id, "user_id" => user_id}) do
    {success, _} = CommunityUsers.delete_community_user_pair(user_id, community_id)
    case success do
      1 -> json(conn, %{status: "ok", csrf: Plug.CSRFProtection.get_csrf_token()})
      _ -> json(conn, %{status: "error", csrf: Plug.CSRFProtection.get_csrf_token()})
    end
  end
end