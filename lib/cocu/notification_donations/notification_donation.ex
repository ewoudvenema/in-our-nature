defmodule Cocu.NotificationDonations.NotificationDonation do
  use Ecto.Schema
  import Ecto.Changeset
  alias Cocu.NotificationDonations.NotificationDonation


  schema "notification_donation" do
    field :notification_id, :id
    field :donation_id, :id

    timestamps()
  end

  @doc false
  def changeset(%NotificationDonation{} = notification_donation, attrs) do
    notification_donation
    |> cast(attrs, [:notification_id, :donation_id])
    |> validate_required([:notification_id, :donation_id])
    |> foreign_key_constraint(:notification_id)
    |> foreign_key_constraint(:donation_id)
  end
end
