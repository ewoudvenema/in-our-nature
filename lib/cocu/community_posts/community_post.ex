defmodule Cocu.CommunityPosts.CommunityPost do
  use Ecto.Schema
  import Ecto.Changeset
  alias Cocu.CommunityPosts.CommunityPost


  schema "community_post" do
    field :user_id, :id
    field :community_id, :id
    field :post_id, :id

    timestamps()
  end

  @doc false
  def changeset(%CommunityPost{} = community_post, attrs) do
    community_post
    |> cast(attrs, [:user_id, :community_id, :post_id])
    |> validate_required([:user_id, :community_id, :post_id])
    |> foreign_key_constraint(:user_id)
    |> foreign_key_constraint(:community_id)
    |> foreign_key_constraint(:post_id)
  end
end
