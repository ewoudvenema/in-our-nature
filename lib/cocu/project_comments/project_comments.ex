defmodule Cocu.ProjectComments do
  @moduledoc """
  The ProjectComments context.
  """

  import Ecto.Query, warn: false
  alias Cocu.Repo

  alias Cocu.ProjectComments.ProjectComment

  @doc """
  Returns the list of project_comment.

  ## Examples

      iex> list_project_comment()
      [%ProjectComment{}, ...]

  """
  def list_project_comment do
    Repo.all(ProjectComment)
  end

  @doc """
  Gets a single project_comment.

  Raises `Ecto.NoResultsError` if the Project comment does not exist.

  ## Examples

      iex> get_project_comment!(123)
      %ProjectComment{}

      iex> get_project_comment!(456)
      ** (Ecto.NoResultsError)

  """
  def get_project_comment!(id), do: Repo.get!(ProjectComment, id)

  @doc """
  Creates a project_comment.

  ## Examples

      iex> create_project_comment(%{field: value})
      {:ok, %ProjectComment{}}

      iex> create_project_comment(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_project_comment(attrs \\ %{}) do
    %ProjectComment{}
    |> ProjectComment.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a project_comment.

  ## Examples

      iex> update_project_comment(project_comment, %{field: new_value})
      {:ok, %ProjectComment{}}

      iex> update_project_comment(project_comment, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_project_comment(%ProjectComment{} = project_comment, attrs) do
    project_comment
    |> ProjectComment.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a ProjectComment.

  ## Examples

      iex> delete_project_comment(project_comment)
      {:ok, %ProjectComment{}}

      iex> delete_project_comment(project_comment)
      {:error, %Ecto.Changeset{}}

  """
  def delete_project_comment(%ProjectComment{} = project_comment) do
    Repo.delete(project_comment)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking project_comment changes.

  ## Examples

      iex> change_project_comment(project_comment)
      %Ecto.Changeset{source: %ProjectComment{}}

  """
  def change_project_comment(%ProjectComment{} = project_comment) do
    ProjectComment.changeset(project_comment, %{})
  end
end
