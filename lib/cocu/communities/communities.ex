defmodule Cocu.Communities do
  @moduledoc """
  The Communities context.
  """

  import Ecto.Query, warn: false
  alias Cocu.Repo
  alias Cocu.Communities.Community


  @doc """
  Returns the list of community.

  ## Examples

      iex> list_community()
      [%Community{}, ...]

  """
  def list_community do
    Repo.all(Community)
  end

  @doc """
  Gets a single community.

  Raises `Ecto.NoResultsError` if the Community does not exist.

  ## Examples

      iex> get_community!(123)
      %Community{}

      iex> get_community!(456)
      ** (Ecto.NoResultsError)

  """
  def get_community!(id), do: Repo.get!(Community, id)

  def get_by_name(name), do: Repo.get_by(Community, name: name)

  @doc """
  Creates a community.

  ## Examples

      iex> create_community(%{field: value})
      {:ok, %Community{}}

      iex> create_community(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_community(attrs \\ %{}) do
    %Community{}
    |> Community.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a community.

  ## Examples

      iex> update_community(community, %{field: new_value})
      {:ok, %Community{}}

      iex> update_community(community, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_community(%Community{} = community, attrs) do
    community
    |> Community.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Community.

  ## Examples

      iex> delete_community(community)
      {:ok, %Community{}}

      iex> delete_community(community)
      {:error, %Ecto.Changeset{}}

  """
  def delete_community(%Community{} = community) do
    Repo.delete(community)
  end

  def delete_community_by_id(id) do
    Repo.get(Community, id)
    |> Repo.delete()
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking community changes.

  ## Examples

      iex> change_community(community)
      %Ecto.Changeset{source: %Community{}}

  """
  def change_community(%Community{} = community) do
    Community.changeset(community, %{})
  end

  @doc """
  Gets community projects.

  """
  def get_community_projects(id) do
    alias Cocu.CommunityProjects.CommunityProject
    alias Cocu.Projects.Project

    query = from c in CommunityProject,
      join: project in Project, on: project.id == c.project_id,
      where: c.community_id == ^id,
      select: %{project_id: c.project_id, vision_name: project.vision_name},
      limit: 4

    Repo.all(query)
  end

  def get_by_order(name, order) do
    query = 
      case order do
        :popularity -> query_by_popularity(name)
        :newest -> query_by_newest(name)
        :name -> query_by_name(name)
        _ -> query_any(name)
      end
    Repo.all(query)
  end

  def get_by_order(name, order, n_entries, offset) do
    query = 
      case order do
        :popularity -> query_by_popularity(name)
        :newest -> query_by_newest(name)
        :name -> query_by_name(name)
        _ -> query_any(name)
      end

    query = from community in subquery(query),
      limit: ^n_entries,
      offset: ^offset

    Repo.all(query)
  end

  def query_any(name) do
    alias Cocu.Users.User

    query = from comnty in Community,
      join: user in User, on: user.id == comnty.founder_id,
      where: like(comnty.name, ^name) and comnty.is_group == false,
      select: %{id: comnty.id, name: comnty.name, description: comnty.description, picture_path: comnty.picture_path, founder_name: user.name}
  end

  def query_by_popularity(name) do
    alias Cocu.Users.User
    
    query = from comnty in Community,
      join: user in User, on: user.id == comnty.founder_id,
      left_join: c in "community_user", on: c.community_id == comnty.id,
      where: like(comnty.name, ^name) and comnty.is_group == false,
      group_by: comnty.id,
      group_by: user.name,
      select: %{id: comnty.id, name: comnty.name, description: comnty.description, picture_path: comnty.picture_path, founder_id: comnty.founder_id, founder_name: user.name},
      order_by: [desc: count(comnty.id)]
  end

  def query_by_newest(name) do
    alias Cocu.Users.User
    
    query = from comnty in Community,
      join: user in User, on: user.id == comnty.founder_id,
      where: like(comnty.name, ^name) and comnty.is_group == false,
      select: %{id: comnty.id, name: comnty.name, description: comnty.description, picture_path: comnty.picture_path, founder_name: user.name},
      order_by: [desc: comnty.inserted_at]
  end

  def query_by_name(name) do
    alias Cocu.Users.User

    query = from comnty in Community,
      join: user in User, on: user.id == comnty.founder_id,
      where: like(comnty.name, ^name) and comnty.is_group == false,
      select: %{id: comnty.id, name: comnty.name, description: comnty.description, picture_path: comnty.picture_path, founder_name: user.name},
      order_by: [asc: comnty.name]
  end

  def get_community_posts(id) do
    alias Cocu.CommunityPosts.CommunityPost
    alias Cocu.Posts.Post
    alias Cocu.Users.User

    query = from post in Post,
      join: cp in CommunityPost, on: cp.post_id == post.id,
      join: usr in User, on: usr.id == cp.user_id,
      #join: pv in VotePost, on: pv.post_id == post.id,
      #join: vote in Vote, on: vote.id == pv.vote_id,  count(vote.positive)
      where: cp.community_id == ^id,
      select: %{community_post_id: cp.id, post_id: post.id, user_id: cp.user_id, user_name: usr.name, title: post.title, date: post.inserted_at}

    Repo.all(query)
  end

  def get_communities_by_user(id) do
    query = from project in "community", where: project.founder_id == ^id, select: map(project, [:id, :name, :inserted_at, :picture_path])
    Repo.all(query)
  end

  def get_communities_user(id) do
    query = from project in "community", where: project.founder_id == ^id, select: map(project, [:id, :name])
    Repo.all(query)
  end

  def get_community_name(id) do
    Repo.get!(Community, id).name
  end

  def is_private(id) do
    Repo.get!(Community, id).is_group
  end

  def get_community_founder_by_project(community_id) do 
    alias Cocu.CommunityUsers.CommunityUser 
    alias Cocu.CommunityProjects.CommunityProject 
    alias Cocu.Projects

    query = from comnty in "community", 
      where: comnty.id == ^community_id, 
      select: %{community_founder_id: comnty.founder_id} 
 
    Repo.all(query) 
  end 

  def get_founder(community_id) do
    Repo.get!(Community, community_id).founder_id
  end

  def get_community_photo(community_id) do
    Repo.get!(Community, community_id).picture_path
  end

  def get_most_popular_communities() do
    alias Cocu.CommunityUsers.CommunityUser
    alias Cocu.Users.User
    
    query = from comnty in Community,
    join: user in User, on: user.id == comnty.founder_id,
    left_join: c in "community_user", on: c.community_id == comnty.id,
    where: comnty.is_group == false,
    group_by: comnty.id,
    group_by: user.name,
    select: %{id: comnty.id, name: comnty.name, description: comnty.description, picture_path: comnty.picture_path, founder_id: comnty.founder_id, founder_name: user.name},
    order_by: [desc: count(comnty.id)],
    limit: 6
    
    Repo.all(query)
  end
end
