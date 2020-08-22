defmodule Cocu.Repo.Migrations.AddAcceptStateProject do
  use Ecto.Migration

  def change do
    alter table(:project) do
      add :accepted, :boolean, default: false, null: false
    end
  end
end
