defmodule Cocu.ProjectPosts do
  @moduledoc """
  The ProjectPosts context.
  """

  import Ecto.Query, warn: false
  alias Cocu.Repo

  alias Cocu.ProjectPosts.ProjectPost

  @doc """
  Returns the list of project_post.

  ## Examples

      iex> list_project_post()
      [%ProjectPost{}, ...]

  """
  def list_project_post do
    Repo.all(ProjectPost)
  end

  @doc """
  Gets a single project_post.

  Raises `Ecto.NoResultsError` if the Project post does not exist.

  ## Examples

      iex> get_project_post!(123)
      %ProjectPost{}

      iex> get_project_post!(456)
      ** (Ecto.NoResultsError)

  """
  def get_project_post!(id), do: Repo.get!(ProjectPost, id)

  @doc """
  Creates a project_post.

  ## Examples

      iex> create_project_post(%{field: value})
      {:ok, %ProjectPost{}}

      iex> create_project_post(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_project_post(attrs \\ %{}) do
    %ProjectPost{}
    |> ProjectPost.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a project_post.

  ## Examples

      iex> update_project_post(project_post, %{field: new_value})
      {:ok, %ProjectPost{}}

      iex> update_project_post(project_post, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_project_post(%ProjectPost{} = project_post, attrs) do
    project_post
    |> ProjectPost.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a ProjectPost.

  ## Examples

      iex> delete_project_post(project_post)
      {:ok, %ProjectPost{}}

      iex> delete_project_post(project_post)
      {:error, %Ecto.Changeset{}}

  """
  def delete_project_post(%ProjectPost{} = project_post) do
    Repo.delete(project_post)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking project_post changes.

  ## Examples

      iex> change_project_post(project_post)
      %Ecto.Changeset{source: %ProjectPost{}}

  """
  def change_project_post(%ProjectPost{} = project_post) do
    ProjectPost.changeset(project_post, %{})
  end

  def delete_project_post_transaction(projectPost) do

    case Cocu.Repo.delete(projectPost) do
        {:error, _} -> :error
        {:ok, _} ->
          post = Cocu.Repo.get_by(Cocu.Posts.Post, id: projectPost.post_id)

              case Cocu.Repo.delete(post) do
                  {:ok, _} -> :ok
                  _ -> :error
              end
    end
  end

  def add_project_post_transaction(params) do
    case Cocu.Posts.create_post(%{title: params["post_title"], content: params["post_content"]}) do
      {:error, _} -> :error
      {:ok, struct} ->
          case Cocu.ProjectPosts.create_project_post(%{user_id: params["user_id"], project_id: params["project_id"], post_id: struct.id}) do
            {:ok, _} -> :ok
            _ -> :error
          end
    end
  end

  def get_n_by_project_with_offset(project_id, n, offset) do
    alias Cocu.Posts.Post
    alias Cocu.ProjectPosts.ProjectPost
    alias Cocu.Users.User
    query = from post in Post,
      join: pp in ProjectPost, on: pp.post_id == post.id,
      join: user in User, on: user.id == pp.user_id,
      where: pp.project_id == ^project_id,
      limit: ^n,
      order_by: [desc: post.updated_at],
      offset: ^offset,
      select: %{project_post_id: pp.id, post_id: post.id, user_id: pp.user_id, user_name: user.name, user_photo: user.picture_path, title: post.title, date: post.inserted_at}
    Repo.all(query)
  end
end
