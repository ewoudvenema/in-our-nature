defmodule Cocu.Notifications.Notification do
  use Ecto.Schema
  import Ecto.Changeset
  alias Cocu.Notifications.Notification


  schema "notification" do
    field :seen, :boolean, default: false

    timestamps()
  end

  @doc false
  def changeset(%Notification{} = notification, attrs) do
    notification
    |> cast(attrs, [:seen])
    |> validate_required([:seen])
  end
end
