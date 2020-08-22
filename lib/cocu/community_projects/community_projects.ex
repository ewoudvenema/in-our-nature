defmodule Cocu.CommunityProjects do
  @moduledoc """
  The CommunityProjects context.
  """

  import Ecto.Query, warn: false
  alias Cocu.Repo

  alias Cocu.CommunityProjects.CommunityProject

  @doc """
  Returns the list of community_project.

  ## Examples

      iex> list_community_project()
      [%CommunityProject{}, ...]

  """
  def list_community_project do
    Repo.all(CommunityProject)
  end

  @doc """
  Gets a single community_project.

  Raises `Ecto.NoResultsError` if the Community project does not exist.

  ## Examples

      iex> get_community_project!(123)
      %CommunityProject{}

      iex> get_community_project!(456)
      ** (Ecto.NoResultsError)

  """
  def get_community_project!(id), do: Repo.get!(CommunityProject, id)

  @doc """
  Creates a community_project.

  ## Examples

      iex> create_community_project(%{field: value})
      {:ok, %CommunityProject{}}

      iex> create_community_project(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_community_project(attrs \\ %{}) do
    %CommunityProject{}
    |> CommunityProject.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a community_project.

  ## Examples

      iex> update_community_project(community_project, %{field: new_value})
      {:ok, %CommunityProject{}}

      iex> update_community_project(community_project, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_community_project(%CommunityProject{} = community_project, attrs) do
    community_project
    |> CommunityProject.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a CommunityProject.

  ## Examples

      iex> delete_community_project(community_project)
      {:ok, %CommunityProject{}}

      iex> delete_community_project(community_project)
      {:error, %Ecto.Changeset{}}

  """
  def delete_community_project(%CommunityProject{} = community_project) do
    Repo.delete(community_project)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking community_project changes.

  ## Examples

      iex> change_community_project(community_project)
      %Ecto.Changeset{source: %CommunityProject{}}

  """
  def change_community_project(%CommunityProject{} = community_project) do
    CommunityProject.changeset(community_project, %{})
  end

end
