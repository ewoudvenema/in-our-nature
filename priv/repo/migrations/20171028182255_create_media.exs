defmodule Cocu.Repo.Migrations.CreateMedia do
  use Ecto.Migration

  def change do
    create table(:media) do
      add :image_path, :string
      add :project_id, references(:project, on_delete: :nothing)

      timestamps()
    end

    create unique_index(:media, [:image_path])
    create index(:media, [:project_id])
  end
end
