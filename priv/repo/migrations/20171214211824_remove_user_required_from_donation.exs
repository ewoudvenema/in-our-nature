defmodule Cocu.Repo.Migrations.RemoveUserRequiredFromDonation do
  use Ecto.Migration

  def change do
    alter table(:donation) do
      modify :user_id, :id, null: true
    end
  end
end
