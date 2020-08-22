defmodule Cocu.Repo.Migrations.UpdateProjectTable do
  use Ecto.Migration

  def change do

    alter table(:project) do
      add :deleted, :boolean, null: false, default: false
    end
  end
end
