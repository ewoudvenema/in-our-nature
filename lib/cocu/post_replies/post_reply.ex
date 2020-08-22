defmodule Cocu.PostReplies.PostReply do
  use Ecto.Schema
  import Ecto.Changeset
  alias Cocu.PostReplies.PostReply


  schema "post_reply" do
    field :content, :string
    field :user_id, :id
    field :post_id, :id

    timestamps()
  end

  @doc false
  def changeset(%PostReply{} = post_reply, attrs) do
    post_reply
    |> cast(attrs, [:content, :user_id, :post_id])
    |> validate_required([:content, :user_id, :post_id])
  end
end
