defmodule CocuWeb.PostApiTest do
    use CocuWeb.ConnCase
    alias Cocu.Users
    alias Cocu.Posts
    alias Cocu.PostReplies
    alias Cocu.Auth.Guardian

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

    describe "create post" do
        setup [:create_post]

        test "get post", %{conn: conn, user: user, post: post, reply: reply} do

            conn = guardian_login(conn, user)
            route = Enum.join(["/api/v1/post/", post.id], "")
        
            response = get conn, route    
            {_, response_body} = Poison.decode(response.resp_body)
            
            assert response_body["title"] == post.title
            assert response_body["content"] == post.content

        end

        test "get post replies", %{conn: conn, user: user, post: post, reply: reply} do

            conn = guardian_login(conn, user)
            route = Enum.join(["/api/v1/post/replies/", post.id], "")

            response = get conn, route    
            {_, response_body} = Poison.decode(response.resp_body)

            Enum.each response_body, fn reply_response -> 
                post_reply = PostReplies.get_post_reply!(reply_response["post_reply_id"])
                assert post_reply.post_id == post.id
            end

          
        end
    end
    

    defp create_post(_) do
        %{user: user, post: post, reply: reply} = fixture(:post)
        {:ok, user: user, post: post, reply: reply}
      end

end
  