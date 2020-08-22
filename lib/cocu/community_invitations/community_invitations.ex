defmodule Cocu.CommunityInvitations do
  @moduledoc """
  The CommunityInvitations context.
  """

  import Ecto.Query, warn: false
  alias Cocu.Repo

  alias Cocu.CommunityInvitations.CommunityInvitation
  alias Cocu.Communities.Community
  alias Cocu.Users.User

  @doc """
  Returns the list of community_invitations.

  ## Examples

      iex> list_community_invitations()
      [%CommunityInvitation{}, ...]

  """
  def list_community_invitations do
    Repo.all(CommunityInvitation)
  end

  @doc """
  Gets a single community_invitation.

  Raises `Ecto.NoResultsError` if the Community invitation does not exist.

  ## Examples

      iex> get_community_invitation!(123)
      %CommunityInvitation{}

      iex> get_community_invitation!(456)
      ** (Ecto.NoResultsError)

  """
  def get_community_invitation!(id), do: Repo.get!(CommunityInvitation, id)

  @doc """
  Creates a community_invitation.

  ## Examples

      iex> create_community_invitation(%{field: value})
      {:ok, %CommunityInvitation{}}

      iex> create_community_invitation(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_community_invitation(attrs \\ %{}) do
    %CommunityInvitation{}
    |> CommunityInvitation.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a community_invitation.

  ## Examples

      iex> update_community_invitation(community_invitation, %{field: new_value})
      {:ok, %CommunityInvitation{}}

      iex> update_community_invitation(community_invitation, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_community_invitation(%CommunityInvitation{} = community_invitation, attrs) do
    community_invitation
    |> CommunityInvitation.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a CommunityInvitation.

  ## Examples

      iex> delete_community_invitation(community_invitation)
      {:ok, %CommunityInvitation{}}

      iex> delete_community_invitation(community_invitation)
      {:error, %Ecto.Changeset{}}

  """
  def delete_community_invitation(%CommunityInvitation{} = community_invitation) do
    Repo.delete(community_invitation)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking community_invitation changes.

  ## Examples

      iex> change_community_invitation(community_invitation)
      %Ecto.Changeset{source: %CommunityInvitation{}}

  """
  def change_community_invitation(%CommunityInvitation{} = community_invitation) do
    CommunityInvitation.changeset(community_invitation, %{})
  end

  @doc """
  Returns the number of entries on the table on which the user identified by its id is the invitee
  """
  def get_invite_count(user_id) do
    query = from invitation in CommunityInvitation,
      where: invitation.invited_id == ^user_id,
      select: count(invitation.id)
    Repo.all(query)
  end

  def get_by_invitee_id(user_id) do
    query = from invitation in CommunityInvitation, 
      join: community in Community, on: community.id == invitation.community_id,
      join: user in User, on: user.id == invitation.inviter_id,
      where: invitation.invited_id == ^user_id,
      select: %{inviter_id: invitation.inviter_id, inviter_picture: user.picture_path, inviter_name: user.name,
       community_id: invitation.community_id, community_name: community.name, inserted_at: invitation.inserted_at}
    Repo.all(query)
  end

  def get_invite(user_id, community_id) do
    query = from invitation in CommunityInvitation,
      where: invitation.invited_id == ^user_id and invitation.community_id == ^community_id
    Repo.all(query)
  end

  def remove_invitation(user_id, community_id) do
    [invite] = get_invite(user_id, community_id)
    delete_community_invitation(invite)
  end
end
