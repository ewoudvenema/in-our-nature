defmodule Cocu.NotificationComments.NotificationComment do
  use Ecto.Schema
  import Ecto.Changeset
  alias Cocu.NotificationComments.NotificationComment


  schema "notification_comment" do
    field :notification_id, :id
    field :project_comment_id, :id

    timestamps()
  end

  @doc false
  def changeset(%NotificationComment{} = notification_comment, attrs) do
    notification_comment
    |> cast(attrs, [:notification_id, :project_comment_id])
    |> validate_required([:notification_id, :project_comment_id])
    |> foreign_key_constraint(:notification_id)
    |> foreign_key_constraint(:project_comment_id)
  end
end
