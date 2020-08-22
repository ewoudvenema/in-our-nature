defmodule Cocu.CommunityUsers.CommunityUser do
  use Ecto.Schema
  import Ecto.Changeset
  alias Cocu.CommunityUsers.CommunityUser


  schema "community_user" do
    field :user_id, :id
    field :community_id, :id

    timestamps()
  end

  @doc false
  def changeset(%CommunityUser{} = community_user, attrs) do
    community_user
    |> cast(attrs, [:user_id, :community_id])
    |> unique_constraint(:user_id_community_id)
    |> validate_required([:user_id, :community_id])
    |> foreign_key_constraint(:user_id)
    |> foreign_key_constraint(:community_id)
  end
end
