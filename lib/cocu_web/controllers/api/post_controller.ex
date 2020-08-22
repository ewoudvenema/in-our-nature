defmodule CocuWeb.V1.PostController do

    use CocuWeb, :controller

    alias Cocu.Repo

    def getPostById(conn, params) do
        post = Repo.get!(Cocu.Posts.Post, params["id"])
        json(conn, %{id: post.id, content: post.content, title: post.title, insert_at: post.inserted_at})
    end

    def getPostReplies(conn, params) do
        replies = Cocu.Posts.get_posts_replies(params["id"])
        json(conn, replies)
    end
end