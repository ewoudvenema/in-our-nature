defmodule CocuWeb.CommnunityUsersTest do
    use CocuWeb.ConnCase

    alias Cocu.Categories
    alias Cocu.Users
    alias Cocu.Communities
    alias Cocu.CommunityUsers
    alias Cocu.Projects
    alias Cocu.Auth.Guardian
    alias Cocu.CommunityInvitations
  
    def fixture(:explore) do
      {:ok, category} = Categories.create_category(%{name: "some category"})
      {:ok, user} = Users.create_user(
        %{
          date_of_birth: ~D[2010-04-17],
          email: "some email",
          name: "some name",
          password: "some password",
          picture_path: "some picture_path",
          privileges_level: "user",
          username: "some username"
        }
      )
      {:ok, community} = Communities.create_community(%{description: "some description", is_group: false, name: "somename", picture_path: "some picture_path", founder_id: user.id})
      %{user: user, community: community}
    end

    def guardian_login(conn, user) do
        bypass_through(conn, CocuWeb.Router, [:browser])
          |> get("/user")
          |> Guardian.Plug.sign_in(user)
          |> send_resp(200, "Flush the session yo")
          #|> recycle()
    end

    describe "Community Users" do
        setup [:create_project]

        test "get available communities", %{conn: conn, user: user, community: community} do
          conn = guardian_login(conn, user)

          route = Enum.join(["/api/v1/community/search?name=", ""], "")
          response = get conn, route
          {_, response_body} = Poison.decode(response.resp_body)

          response_length = Enum.count(response_body["results"])

          {:ok, community2} = Communities.create_community(%{description: "new description", is_group: false, name: "some name 2", picture_path: "some picture_path", founder_id: user.id})
          
          new_route = Enum.join(["/api/v1/community/search?name=", ""], "")
          new_response = get conn, new_route
          {_, new_response_body} = Poison.decode(new_response.resp_body)

          assert (response_length + 1) == Enum.count(new_response_body["results"])

        end 

        test "toggle follow community", %{conn: conn, user: user, community: community} do
          conn = guardian_login(conn, user)

          response_length = Enum.count(CommunityUsers.get_followed_communities(user.id))

          route2 = Enum.join(["/api/v1/user/follow_community/toggle_follow/", community.id], "")
          post conn, route2
          
          communities_count =  Enum.count(CommunityUsers.get_followed_communities(user.id))

          assert communities_count == (response_length + 1)

          route3 = Enum.join(["/api/v1/user/follow_community/toggle_follow/", community.id], "")
          post conn, route3
          
          communities_count2 =  Enum.count(CommunityUsers.get_followed_communities(user.id))

          assert communities_count2 == (response_length)
        end 


        test "accept invitation", %{conn: conn, user: user, community: community} do

          {:ok, user2} = Users.create_user(
            %{
              date_of_birth: ~D[2010-04-17],
              email: "some@email",
              name: "some name",
              password: "some password",
              picture_path: "some picture_path",
              privileges_level: "user",
              username: "some username"
            }
          )

          conn = guardian_login(conn, user2)    

          {:ok, invitation} = CommunityInvitations.create_community_invitation(%{inviter_id: user.id, invited_id: user2.id, community_id: community.id})          

          invites_count = Enum.count(CommunityInvitations.get_invite(user2.id, community.id))

          route = Enum.join(["/api/v1//user/follow_community/accept_invitation/", community.id], "")

          response = post conn, route
          {_, response_body} = Poison.decode(response.resp_body)

          invites_count2 = Enum.count(CommunityInvitations.get_invite(user2.id, community.id))

          assert invites_count == (invites_count2 + 1)

        end
        
        test "reject invitation", %{conn: conn, user: user, community: community} do
          
          {:ok, user2} = Users.create_user(
            %{
              date_of_birth: ~D[2010-04-17],
              email: "some@email",
              name: "some name",
              password: "some password",
              picture_path: "some picture_path",
              privileges_level: "user",
              username: "some username"
            }
          )

          conn = guardian_login(conn, user2)    

          {:ok, invitation} = CommunityInvitations.create_community_invitation(%{inviter_id: user.id, invited_id: user2.id, community_id: community.id})          

          invites_count = Enum.count(CommunityInvitations.get_invite(user2.id, community.id))

          route = Enum.join(["/api/v1/user/follow_community/reject_invitation/", community.id], "")

          response = post conn, route
          {_, response_body} = Poison.decode(response.resp_body)

          invites_count2 = Enum.count(CommunityInvitations.get_invite(user2.id, community.id))

          assert invites_count == (invites_count2 + 1)

        end 

        test "retrieve followers", %{conn: conn, user: user, community: community} do

          {:ok, user2} = Users.create_user(
            %{
              date_of_birth: ~D[2010-04-17],
              email: "some@email",
              name: "some name",
              password: "some password",
              picture_path: "some picture_path",
              privileges_level: "user",
              username: "some username"
            }
          )

          conn = guardian_login(conn, user)    

          route = Enum.join(["/api/v1/community/get_followers?community_id=", community.id, "&page=0"], "")

          response = get conn, route
          {_, response_body} = Poison.decode(response.resp_body)

          followers_count = Enum.count(response_body["users"])

          CommunityUsers.create_community_user(%{"user_id" => user2.id, "community_id" => community.id})
          
          route2 = Enum.join(["/api/v1/community/get_followers?community_id=", community.id, "&page=0"], "")
          
          response2 = get conn, route2
          {_, response_body2} = Poison.decode(response2.resp_body)

          followers_count2 = Enum.count(response_body2["users"])

          assert (followers_count + 1) == followers_count2

        end

        test "remove users", %{conn: conn, user: user, community: community} do
          
          {:ok, user2} = Users.create_user(
            %{
              date_of_birth: ~D[2010-04-17],
              email: "some@email",
              name: "some name",
              password: "some password",
              picture_path: "some picture_path",
              privileges_level: "user",
              username: "some username"
            }
          )

          conn = guardian_login(conn, user2)   

          CommunityUsers.create_community_user(%{"user_id" => user2.id, "community_id" => community.id})

          communities_count = Enum.count(CommunityUsers.get_followed_communities(user2.id))

          route = Enum.join(["/api/v1//community/remove_user?community_id=", community.id, "&user_id=", user2.id], "")

          response = post conn, route
          {_, response_body} = Poison.decode(response.resp_body)

          communities_count2 = Enum.count(CommunityUsers.get_followed_communities(user2.id))

          assert communities_count == (communities_count2 + 1)        

        end
    end

    defp create_project(_) do
        %{user: user, community: community} = fixture(:explore)
        {:ok, user: user, community: community}
    end
    
end  