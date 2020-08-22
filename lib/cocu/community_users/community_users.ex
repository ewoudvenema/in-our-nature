defmodule Cocu.CommunityUsers do
  @moduledoc """
  The CommunityUsers context.
  """

  import Ecto.Query, warn: false
  alias Cocu.Repo

  alias Cocu.CommunityUsers.CommunityUser

  @doc """
  Returns the list of community_user.

  ## Examples

      iex> list_community_user()
      [%CommunityUser{}, ...]

  """
  def list_community_user do
    Repo.all(CommunityUser)
  end

  @doc """
  Gets a single community_user.

  Raises `Ecto.NoResultsError` if the Community user does not exist.

  ## Examples

      iex> get_community_user!(123)
      %CommunityUser{}

      iex> get_community_user!(456)
      ** (Ecto.NoResultsError)

  """
  def get_community_user!(id), do: Repo.get!(CommunityUser, id)

  @doc """
  Creates a community_user.

  ## Examples

      iex> create_community_user(%{field: value})
      {:ok, %CommunityUser{}}

      iex> create_community_user(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_community_user(attrs \\ %{}) do
    %CommunityUser{}
    |> CommunityUser.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a community_user.

  ## Examples

      iex> update_community_user(community_user, %{field: new_value})
      {:ok, %CommunityUser{}}

      iex> update_community_user(community_user, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_community_user(%CommunityUser{} = community_user, attrs) do
    community_user
    |> CommunityUser.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a CommunityUser.

  ## Examples

      iex> delete_community_user(community_user)
      {:ok, %CommunityUser{}}

      iex> delete_community_user(community_user)
      {:error, %Ecto.Changeset{}}

  """
  def delete_community_user(%CommunityUser{} = community_user) do
    Repo.delete(community_user)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking community_user changes.

  ## Examples

      iex> change_community_user(community_user)
      %Ecto.Changeset{source: %CommunityUser{}}

  """
  def change_community_user(%CommunityUser{} = community_user) do
    CommunityUser.changeset(community_user, %{})
  end

  def get_user_communities(user_id) do
    query = from pair in CommunityUser, where: pair.user_id == ^user_id 
    query = from pair in query, join: community in Cocu.Communities.Community, where: pair.community_id == community.id
    query = from [pair, community] in query, select: [community.id, community.name], order_by: [asc: community.name]
    Repo.all(query)
  end

  def user_follows_community(user_id, community_id) do
    query = from pair in CommunityUser, where: pair.user_id == ^user_id and pair.community_id == ^community_id
    Repo.all(query)
  end

  def get_followed_communities(id) do
    communities_query = 
    from community in "community_user", 
    join: c in "community", on: c.id == community.community_id,
    where: community.user_id == ^id, 
    select: %{name: c.name, community_id: community.community_id, picture_path: c.picture_path, inserted_at: community.inserted_at}
    
    Repo.all(communities_query)
  end

  def delete_community_user_pair(user_id, community_id) do
    query = from pair in CommunityUser, where: pair.user_id == ^user_id and pair.community_id == ^community_id
    Repo.delete_all(query)
  end

  def get_num_followers(community_id) do
    query = from pair in CommunityUser, where: pair.community_id == ^community_id, select: count(pair.id)
    Repo.all(query)
  end

  @doc """
    Return n users following a community identified by its id
    starting at an offset
  """
  def get_n_users(community_id, n_rows, offset) do
    query = from pair in CommunityUser,
      join: user in Cocu.Users.User, where: pair.user_id == user.id,
      where: pair.community_id == ^community_id,
      select: %{id: user.id, name: user.name, photo: user.picture_path},
      order_by: user.name,
      limit: ^n_rows,
      offset: ^offset
    Repo.all(query)
  end

  @doc """
  Get a list of community names and ids for all the public communities and 
  for all the private communities which the user follows
  """
  def get_available_communities(user_id, name) do
    alias Cocu.Communities.Community

    name = name <> "%"

    query = from community in Community,
    where: community.is_group == false and like(community.name, ^name), # get all public communities
    select: %{name: community.name, value: community.id, text: community.name} # I'm not sure why this text value is here, but I am not removing it
    results = Repo.all(query)

    # get all the private communities the user follows
    query = from community in Community,
    join: pair in CommunityUser, on: community.id == pair.community_id,
    where: like(community.name, ^name) and community.is_group == true and pair.user_id == ^user_id,
    select: %{name: community.name, value: community.id, text: community.name}
    results = results ++ Repo.all(query) # join the two queries

    results
      |> Enum.uniq() # make sure there are no duplicates, should not be needed 
      |> Enum.sort(fn(%{name: name1}, %{name: name2}) -> String.downcase(name1) < String.downcase(name2) end) # sort alphabetically
  end
end
