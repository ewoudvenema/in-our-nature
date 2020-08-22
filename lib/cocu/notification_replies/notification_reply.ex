defmodule Cocu.NotificationReplies.NotificationReply do
  use Ecto.Schema
  import Ecto.Changeset
  alias Cocu.NotificationReplies.NotificationReply


  schema "notification_reply" do
    field :notification_id, :id
    field :post_reply_id, :id

    timestamps()
  end

  @doc false
  def changeset(%NotificationReply{} = notification_reply, attrs) do
    notification_reply
    |> cast(attrs, [:notification_id, :post_reply_id])
    |> validate_required([:notification_id, :post_reply_id])
    |> foreign_key_constraint(:notification_id)
    |> foreign_key_constraint(:post_reply_id)
  end
end
