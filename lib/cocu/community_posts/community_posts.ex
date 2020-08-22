defmodule Cocu.CommunityPosts do
  @moduledoc """
  The CommunityPosts context.
  """

  import Ecto.Query, warn: false
  alias Cocu.Repo

  alias Cocu.CommunityPosts.CommunityPost

  @doc """
  Returns the list of community_post.

  ## Examples

      iex> list_community_post()
      [%CommunityPost{}, ...]

  """
  def list_community_post do
    Repo.all(CommunityPost)
  end

  @doc """
  Gets a single community_post.

  Raises `Ecto.NoResultsError` if the Community post does not exist.

  ## Examples

      iex> get_community_post!(123)
      %CommunityPost{}

      iex> get_community_post!(456)
      ** (Ecto.NoResultsError)

  """
  def get_community_post!(id), do: Repo.get!(CommunityPost, id)

  @doc """
  Creates a community_post.

  ## Examples

      iex> create_community_post(%{field: value})
      {:ok, %CommunityPost{}}

      iex> create_community_post(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_community_post(attrs \\ %{}) do
    %CommunityPost{}
    |> CommunityPost.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a community_post.

  ## Examples

      iex> update_community_post(community_post, %{field: new_value})
      {:ok, %CommunityPost{}}

      iex> update_community_post(community_post, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_community_post(%CommunityPost{} = community_post, attrs) do
    community_post
    |> CommunityPost.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a CommunityPost.

  ## Examples

      iex> delete_community_post(community_post)
      {:ok, %CommunityPost{}}

      iex> delete_community_post(community_post)
      {:error, %Ecto.Changeset{}}

  """
  def delete_community_post(%CommunityPost{} = community_post) do
    Repo.delete(community_post)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking community_post changes.

  ## Examples

      iex> change_community_post(community_post)
      %Ecto.Changeset{source: %CommunityPost{}}

  """
  def change_community_post(%CommunityPost{} = community_post) do
    CommunityPost.changeset(community_post, %{})
  end

  def delete_community_post_transaction(communityPost) do
    
    case Cocu.Repo.delete(communityPost) do
      {:error, _} -> :error
      {:ok, _} ->
        post = Cocu.Repo.get_by(Cocu.Posts.Post, id: communityPost.post_id)
        
      case Cocu.Repo.delete(post) do
        {:ok, _} -> :ok
        _ -> :error
      end  
    end  
  end

  def add_community_post_transaction(params) do
    case Cocu.Posts.create_post(%{title: params["post_title"], content: params["post_content"]}) do
      {:error, _} -> :error
      {:ok, struct} -> 
          case Cocu.CommunityPosts.create_community_post(%{user_id: params["user_id"], community_id: params["community_id"], post_id: struct.id}) do
            {:ok, _} -> :ok
            _ -> :error
          end
    end
  end

  def get_n_posts_with_offset(community_id, n, offset) do
    alias Cocu.Posts.Post
    alias Cocu.CommunityPosts.CommunityPost
    alias Cocu.Users.User
    query = from post in Post,
      join: cp in CommunityPost, on: cp.post_id == post.id,
      join: user in User, on: user.id == cp.user_id,
      where: cp.community_id == ^community_id,
      limit: ^n,
      order_by: [desc: post.updated_at],
      offset: ^offset,
      select: %{community_post_id: cp.id, post_id: post.id, user_id: cp.user_id, user_name: user.name, title: post.title, date: post.inserted_at, user_photo: user.picture_path}

    Repo.all(query)
  end
end
