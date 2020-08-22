defmodule Cocu.UserFollowUsers.UserFollowUser do
  use Ecto.Schema
  import Ecto.Changeset
  alias Cocu.UserFollowUsers.UserFollowUser


  schema "user_follow_user" do
    field :followed_user_id, :id
    field :follower_user_id, :id

    timestamps()
  end

  @doc false
  def changeset(%UserFollowUser{} = user_follow_user, attrs) do
    user_follow_user
    |> cast(attrs, [:followed_user_id, :follower_user_id])
    |> validate_required([:followed_user_id, :follower_user_id])
    |> foreign_key_constraint(:followed_user_id)
    |> foreign_key_constraint(:follower_user_id)
  end
end
