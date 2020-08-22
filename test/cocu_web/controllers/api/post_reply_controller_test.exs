defmodule CocuWeb.PostReplyApiController do
    use CocuWeb.ConnCase
    alias Cocu.Auth.Guardian
    alias Cocu.Posts
    alias Cocu.Users
    alias Cocu.PostReplies

    def fixture(:post) do
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
        {:ok, reply} = PostReplies.create_post_reply(%{
            content: "Reply Content",
            user_id: user.id,
            post_id: post.id
        })
        %{user: user, post: post, reply: reply}
    end

    def guardian_login(conn, user) do
        bypass_through(conn, CocuWeb.Router, [:browser])
            |> get("/user")
            |> Guardian.Plug.sign_in(user)
            |> send_resp(200, "Flush the session yo")
            |> recycle()
    end

    describe "Post Reply controller tests" do
        setup [:create_post_reply]

        test "Add post reply",  %{conn: conn, user: user, post: post} do
            conn = guardian_login(conn, user)
            route = Enum.join(["/api/v1/post_reply/new", "?post_id=", post.id, "&user_id=", user.id, "&content=", "TestReply"], "")

            response = post conn, route
            {_, response_body} = Poison.decode(response.resp_body)

            assert json_response(response,200)
            assert response_body["content"] == "TestReply"
            assert response_body["userId"] == user.id
        end

        test "Get reply by id", %{conn: conn, user: user, post: post, reply: reply} do
            conn = guardian_login(conn, user)
            route = Enum.join(["/api/v1/post_reply/", reply.id], "")
            
            response = get conn, route
            {_, response_body} = Poison.decode(response.resp_body)
            assert json_response(response,200)
            assert response_body["id"] == reply.id
        end

        test "Delete reply with id ", %{conn: conn, user: user, reply: reply} do
            conn = guardian_login(conn, user)
            route = Enum.join(["/api/v1/post_reply/delete/", reply.id], "")
            
            response = delete conn, route
            {_, response_body} = Poison.decode(response.resp_body)
            assert json_response(response,200)
            assert response_body["message"] == "sucess"
        end

        test "Edit reply ", %{conn: conn, user: user, reply: reply} do
            conn = guardian_login(conn, user)
            route = Enum.join(["/api/v1/post_reply/edit/", reply.id,"?reply_content=" ,"Edit"], "")

            response = put conn, route
            {_, response_body} = Poison.decode(response.resp_body)
            assert json_response(response,200)
            assert response_body["message"] == "sucess"
        end
    end

    defp create_post_reply(_) do
        %{user: user, post: post, reply: reply} = fixture(:post)
        {:ok, user: user, post: post, reply: reply}
    end
end