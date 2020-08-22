defmodule Cocu.Posts do
  @moduledoc """
  The Posts context.
  """

  import Ecto.Query, warn: false
  alias Cocu.Repo

  alias Cocu.Posts.Post

  @doc """
  Returns the list of post.

  ## Examples

      iex> list_post()
      [%Post{}, ...]

  """
  def list_post do
    Repo.all(Post)
  end

  @doc """
  Gets a single post.

  Raises `Ecto.NoResultsError` if the Post does not exist.

  ## Examples

      iex> get_post!(123)
      %Post{}

      iex> get_post!(456)
      ** (Ecto.NoResultsError)

  """
  def get_post!(id), do: Repo.get!(Post, id)

  @doc """
  Creates a post.

  ## Examples

      iex> create_post(%{field: value})
      {:ok, %Post{}}

      iex> create_post(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_post(attrs \\ %{}) do
    %Post{}
    |> Post.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a post.

  ## Examples

      iex> update_post(post, %{field: new_value})
      {:ok, %Post{}}

      iex> update_post(post, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_post(%Post{} = post, attrs) do
    post
    |> Post.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Post.

  ## Examples

      iex> delete_post(post)
      {:ok, %Post{}}

      iex> delete_post(post)
      {:error, %Ecto.Changeset{}}

  """
  def delete_post(%Post{} = post) do
    Repo.delete(post)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking post changes.

  ## Examples

      iex> change_post(post)
      %Ecto.Changeset{source: %Post{}}

  """
  def change_post(%Post{} = post) do
    Post.changeset(post, %{})
  end

  def get_posts_replies(id) do
    alias Cocu.PostReplies.PostReply
    alias Cocu.Users.User

    query = from pr in PostReply,
              join: usr in User, on: usr.id == pr.user_id,
              where: pr.post_id == ^id,
              select: %{post_reply_id: pr.id, post_reply_content: pr.content, inserted_at: pr.inserted_at, user_id: usr.id, user_name: usr.name, user_picture_path: usr.picture_path}

    Repo.all(query);
  end

  def edit_post(params) do
    post = Cocu.Repo.get!(Cocu.Posts.Post, params["id"])
    post = Ecto.Changeset.change post, title: params["post_title"], content: params["post_content"]

    case Cocu.Repo.update(post) do
        {:ok, _struct} -> :ok
        _ -> :error
    end
  end
end