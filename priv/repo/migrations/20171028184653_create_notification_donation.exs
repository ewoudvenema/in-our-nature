defmodule Cocu.Repo.Migrations.CreateNotificationDonation do
  use Ecto.Migration

  def change do
    create table(:notification_donation) do
      add :notification_id, references(:notification, on_delete: :nothing)
      add :donation_id, references(:donation, on_delete: :nothing)

      timestamps()
    end

    create index(:notification_donation, [:notification_id])
    create index(:notification_donation, [:donation_id])
  end
end
