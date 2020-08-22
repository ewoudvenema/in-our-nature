defmodule CocuWeb.UserInviteTest do
    use CocuWeb.ConnCase
  
    alias Cocu.Users
    alias Cocu.Communities
    alias Cocu.CommunityUsers
    alias Cocu.CommunityInvitations
    alias Cocu.Auth.Guardian
  
    def fixture(:invite) do
      {:ok, user1} = Users.create_user(
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
      {:ok, user2} = Users.create_user(
        %{
          date_of_birth: ~D[2010-04-17],
          email: "some@email",
          name: "user2",
          password: "some password",
          picture_path: "some picture_path",
          privileges_level: "user",
          username: "some username"
        }
      )
      {:ok, community} = Communities.create_community(%{description: "some description", is_group: true, name: "some name", picture_path: "some picture_path", founder_id: user1.id})
      %{user1: user1, user2: user2, community: community}
    end
  
    def guardian_login(conn, user) do
      bypass_through(conn, CocuWeb.Router, [:browser])
        |> get("/user")
        |> Guardian.Plug.sign_in(user)
        |> send_resp(200, "Flush the session yo")
        |> recycle()
    end
  
    describe "invite user" do
      setup [:create_community]
  
      test "invite user to community", %{conn: conn, user1: user1, user2: user2, community: community} do
        
        conn = guardian_login(conn, user1)

        list = CommunityUsers.user_follows_community(user2.id, community.id)
        assert Enum.empty?(list) == true
  
        route = Enum.join(["/api/v1/community/invite_user/?invitee_info=", user2.email, "&community_id=", community.id])

        response = post conn, route

        list2 = CommunityInvitations.get_invite(user2.id, community.id)

        assert Enum.empty?(list2) == false
      end

    end
  
    defp create_community(_) do
      %{user1: user1, user2: user2, community: community} = fixture(:invite)
      {:ok, user1: user1, user2: user2, community: community}
    end
  end
  