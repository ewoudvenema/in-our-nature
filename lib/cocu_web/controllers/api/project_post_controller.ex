defmodule CocuWeb.V1.ProjectPostController do

  use CocuWeb, :controller

  def addProjectPost(conn, params) do
    case Cocu.Repo.transaction(fn ->
      Cocu.ProjectPosts.add_project_post_transaction(params) end) do
        {:ok, :ok} -> json(conn, %{status: "ok"})
        _ -> json(conn, %{status: "error"})
    end
  end

  def editProjectPost(conn, params) do
    projectPost = Cocu.Repo.get_by(Cocu.ProjectPosts.ProjectPost, post_id: params["id"])

    if Guardian.Plug.current_resource(conn).id == projectPost.user_id do
      case Cocu.Posts.edit_post(params) do
        :ok -> json(conn, %{status: "ok"})
        _ -> json(conn, %{status: "error"})
        end
      else
         json(conn, %{status: "error"})
      end
    end


  def deleteProjectPost(conn, params) do
    projectPost = Cocu.Repo.get_by(Cocu.ProjectPosts.ProjectPost, post_id: params["id"])

    if Guardian.Plug.current_resource(conn).id == projectPost.user_id do
      case Cocu.Repo.transaction(fn -> Cocu.ProjectPosts.delete_project_post_transaction(projectPost) end) do
        {:ok, :ok} -> json(conn, %{status: "ok"})
        _ ->json(conn, %{status: "error"})
      end
    else
     json(conn, %{status: "error"})
    end
  end


  def get_by_page(conn, %{"project_id" => project_id, "page" => page}) do
    current_id =
      case Guardian.Plug.current_resource(conn) do
          nil -> -1
          _ -> Guardian.Plug.current_resource(conn).id
      end
    posts = Cocu.ProjectPosts.get_n_by_project_with_offset(String.to_integer(project_id), 10, 10 * String.to_integer(page))

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
