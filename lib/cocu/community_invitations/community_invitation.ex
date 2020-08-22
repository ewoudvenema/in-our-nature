defmodule Cocu.CommunityInvitations.CommunityInvitation do
  use Ecto.Schema
  import Ecto.Changeset
  alias Cocu.CommunityInvitations.CommunityInvitation


  schema "community_invitations" do
    field :inviter_id, :id
    field :invited_id, :id
    field :community_id, :id

    timestamps()
  end

  @doc false
  def changeset(%CommunityInvitation{} = community_invitation, attrs) do
    community_invitation
    |> cast(attrs, [:inviter_id, :invited_id, :community_id])
    |> validate_required([:inviter_id, :invited_id, :community_id])
    |> unique_constraint(:invited_id_community_id)
    |> foreign_key_constraint(:inviter_id)
    |> foreign_key_constraint(:invited_id)
    |> foreign_key_constraint(:community_id)
  end
end
