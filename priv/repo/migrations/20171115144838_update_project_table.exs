defmodule Cocu.Repo.Migrations.UpdateProjectTable do
  use Ecto.Migration

  def change do
    execute("create type project_impact as enum ('regional', 'national', 'international', 'global')")

    alter table(:project) do
      add :location, :string, null: false
      add :impact, :project_impact, default: "national"
    end
  end
end
