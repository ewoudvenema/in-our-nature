defmodule Cocu.Repo.Migrations.CreateNotification do
  use Ecto.Migration

  def change do
    create table(:notification) do
      add :seen, :boolean, default: false, null: false

      timestamps()
    end

  end
end
