defmodule CocuWeb.V1.CommunityPostController do

    use CocuWeb, :controller

    def addCommunityPost(conn, params) do
      case Guardian.Plug.current_resource(conn) do  
        nil -> json(conn, status: :error)
        _ -> case Cocu.Repo.transaction(fn -> 
                Cocu.CommunityPosts.add_community_post_transaction(params) end) do 
                {:ok, :ok} -> json(conn, %{status: "ok"})
                _ -> json(conn, %{status: "error"})
            end
      end
    end

    def editCommunityPost(conn, params) do
      communityPost = Cocu.Repo.get_by(Cocu.CommunityPosts.CommunityPost, post_id: params["id"])
        if Guardian.Plug.current_resource(conn).id == communityPost.user_id do
            case Cocu.Posts.edit_post(params) do
                :ok -> json(conn, %{status: "ok"})
                _ -> json(conn, %{status: "error"})
            end
        else
            json(conn, %{status: "error"})
        end
    end

    def deleteCommunityPost(conn, params) do
        communityPost = Cocu.Repo.get_by(Cocu.CommunityPosts.CommunityPost, post_id: params["id"])

        if Guardian.Plug.current_resource(conn).id == communityPost.user_id do
            case Cocu.Repo.transaction(fn -> 
                    Cocu.CommunityPosts.delete_community_post_transaction(communityPost) end) do 
                {:ok, :ok} -> json(conn, %{status: "ok"})
                    _ -> json(conn, %{status: "error"})
            end
            else
            json(conn, %{status: "error"})
        end
    end

    def get_by_page(conn, %{"community_id" => community_id, "page" => page}) do
        current_id = 
            case Guardian.Plug.current_resource(conn) do
                nil -> -1 
                _ -> Guardian.Plug.current_resource(conn).id
            end
        posts = Cocu.CommunityPosts.get_n_posts_with_offset(String.to_integer(community_id), 10, 10 * String.to_integer(page))

        # Place a k,v pair indicating if the user requesting each post has created it
        posts = Enum.map(posts, 
          fn (post = %{user_id: creator_id}) ->
            case creator_id do
                current_id -> post = Map.put(post, :is_creator, true)
                _ -> post = Map.put(post, :is_creator, false)
            end 
            post
          end
        )
        json(conn, %{posts: posts, csrf: Plug.CSRFProtection.get_csrf_token})
    end
end