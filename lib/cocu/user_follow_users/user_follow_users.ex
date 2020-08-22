defmodule Cocu.UserFollowUsers do
  @moduledoc """
  The UserFollowUsers context.
  """

  import Ecto.Query, warn: false
  alias Cocu.Repo

  alias Cocu.UserFollowUsers.UserFollowUser

  @doc """
  Returns the list of user_follow_user.

  ## Examples

      iex> list_user_follow_user()
      [%UserFollowUser{}, ...]

  """
  def list_user_follow_user do
    Repo.all(UserFollowUser)
  end

  @doc """
  Gets a single user_follow_user.

  Raises `Ecto.NoResultsError` if the User follow user does not exist.

  ## Examples

      iex> get_user_follow_user!(123)
      %UserFollowUser{}

      iex> get_user_follow_user!(456)
      ** (Ecto.NoResultsError)

  """
  def get_user_follow_user!(id), do: Repo.get!(UserFollowUser, id)

  @doc """
  Creates a user_follow_user.

  ## Examples

      iex> create_user_follow_user(%{field: value})
      {:ok, %UserFollowUser{}}

      iex> create_user_follow_user(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_user_follow_user(attrs \\ %{}) do
    %UserFollowUser{}
    |> UserFollowUser.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a user_follow_user.

  ## Examples

      iex> update_user_follow_user(user_follow_user, %{field: new_value})
      {:ok, %UserFollowUser{}}

      iex> update_user_follow_user(user_follow_user, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_user_follow_user(%UserFollowUser{} = user_follow_user, attrs) do
    user_follow_user
    |> UserFollowUser.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a UserFollowUser.

  ## Examples

      iex> delete_user_follow_user(user_follow_user)
      {:ok, %UserFollowUser{}}

      iex> delete_user_follow_user(user_follow_user)
      {:error, %Ecto.Changeset{}}

  """
  def delete_user_follow_user(%UserFollowUser{} = user_follow_user) do
    Repo.delete(user_follow_user)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking user_follow_user changes.

  ## Examples

      iex> change_user_follow_user(user_follow_user)
      %Ecto.Changeset{source: %UserFollowUser{}}

  """
  def change_user_follow_user(%UserFollowUser{} = user_follow_user) do
    UserFollowUser.changeset(user_follow_user, %{})
  end
end
