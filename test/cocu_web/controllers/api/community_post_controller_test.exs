defmodule CocuWeb.CommunityPostAPITest do
    use CocuWeb.ConnCase

    alias Cocu.Categories
    alias Cocu.Posts
    alias Cocu.Users
    alias Cocu.Communities
    alias Cocu.CommunityPosts
    alias Cocu.Auth.Guardian

    def fixture(:community_post) do
        {:ok, category} = Categories.create_category(%{name: "some category"})
        {:ok, post} = Posts.create_post(%{content: "Some Post", title: "Post Title"})
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
        {:ok, community} = Communities.create_community(
            %{
                description: "some description",
                is_group: true,
                name: "some name",
                picture_path: "some picture_path",
                founder_id: user.id
            }
        )
        {:ok, community_post} = CommunityPosts.create_community_post(%{user_id: user.id, community_id: community.id, post_id: post.id})
        %{post: post, user: user, community: community, community_post: community_post}
    end

    def guardian_login(conn, user) do
        bypass_through(conn, CocuWeb.Router, [:browser])
          |> get("/user")
          |> Guardian.Plug.sign_in(user)
          |> send_resp(200, "Flush the session yo")
    end

    describe "add_community_post" do 
       setup [:create_community_post] 

       test "insert_good_post", %{conn: conn, community: community, post: post, user: user} do
        conn = guardian_login(conn, user)
        route = Enum.join(["/api/v1/community_post/new?post_title=", URI.encode(post.title), "&post_content=",URI.encode(post.content), "&user_id=", user.id, "&community_id=", community.id])

        response = post conn, route
        assert json_response(response, 200)

        {_, response_body} = Poison.decode(response.resp_body)
        assert response_body["status"] == "ok"
       end

       test "insert_bad_community_id", %{conn: conn, community: community, post: post, user: user} do
        conn = guardian_login(conn, user)
        community_id = -1
        route = Enum.join(["/api/v1/community_post/new?post_title=", URI.encode(post.title), "&post_content=",URI.encode(post.content), "&user_id=", user.id, "&community_id=", community_id])

        response = post conn, route
        assert json_response(response, 200)

        {_, response_body} = Poison.decode(response.resp_body)
        assert response_body["status"] == "error"
       end

       test "insert_bad_user_id", %{conn: conn, community: community, post: post, user: user} do
        conn = guardian_login(conn, user)
        user_id = -1
        route = Enum.join(["/api/v1/community_post/new?post_title=", URI.encode(post.title), "&post_content=",URI.encode(post.content), "&user_id=", user_id, "&community_id=", community.id])

        response = post conn, route
        assert json_response(response, 200)

        {_, response_body} = Poison.decode(response.resp_body)
        assert response_body["status"] == "error"
       end
    end

    describe "edit_project_post" do
       setup [:create_community_post] 

       test "edit_good_post", %{conn: conn, community: community, post: post, user: user, community_post: community_post} do

        new_title = "New Title"
        new_content = "New content"

        conn = guardian_login(conn, user)
        route = Enum.join(["/api/v1/community_post/edit/",community_post.post_id,"?post_title=", URI.encode(new_title), "&post_content=",URI.encode(new_content)])

        response = put conn, route
        assert json_response(response, 200)

        {_, response_body} = Poison.decode(response.resp_body)
        assert response_body["status"] == "ok"

        post = Posts.get_post!(community_post.post_id)
        assert post.content == "New content"
        assert post.title == "New Title"
       end
    end

    describe "delete_project_post" do
       setup [:create_community_post] 

       test "delete_post_success", %{conn: conn, community: community, post: post, user: user, community_post: community_post} do
            conn = guardian_login(conn, user)

            cp_count = Enum.count(CommunityPosts.list_community_post())

            route = Enum.join(["/api/v1/community_post/delete/",community_post.post_id])
            response = delete conn, route
            assert json_response(response, 200)

            {_, response_body} = Poison.decode(response.resp_body)
            assert response_body["status"] == "ok"
            assert cp_count = Enum.count(CommunityPosts.list_community_post()) - 1
        end
    end

    describe "post_pages" do
        setup [:create_community_post]

        test "test_new_post_in_page", %{conn: conn, community: community, post: post, user: user, community_post: community_post} do
            conn = guardian_login(conn, user)

            route = Enum.join(["/api/v1/community_post/get_page?page=0&community_id=", community.id])
            response = get conn, route
            assert json_response(response, 200)

            {_, response_body} = Poison.decode(response.resp_body)
            assert not Enum.empty? response_body["posts"]
        end
    end

    defp create_community_post(_) do
        %{post: post, user: user, community: community, community_post: community_post} = fixture(:community_post)
        {:ok, post: post, user: user, community: community, community_post: community_post}
      end
end