defmodule Cocu.ReplyPostReplies.ReplyPostReply do
  use Ecto.Schema
  import Ecto.Changeset
  alias Cocu.ReplyPostReplies.ReplyPostReply


  schema "reply_post_reply" do
    field :parent_post_reply_id, :id
    field :child_post_reply_id, :id

    timestamps()
  end

  @doc false
  def changeset(%ReplyPostReply{} = reply_post_reply, attrs) do
    reply_post_reply
    |> cast(attrs, [:parent_post_reply_id, :child_post_reply_id])
    |> validate_required([:parent_post_reply_id, :child_post_reply_id])
    |> foreign_key_constraint(:parent_post_reply_id)
    |> foreign_key_constraint(:child_post_reply_id)
  end
end
