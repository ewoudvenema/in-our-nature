defmodule Cocu.Repo.Migrations.CreateProject do
  use Ecto.Migration

  def change do
    execute("create type project_status as enum ('presentation', 'funding', 'creation')", "drop type project_status")

    create table(:project) do
      add :vision_name, :string, null: false
      add :planning, :string, null: false
      add :vision, :string, null: false
      add :benefits, :string, null: false
      add :fund_asked, :float, null: false
      add :fund_limit_date, :date, null: false
      add :website, :string, null: false
      add :current_fund, :float, default: 0
      add :state, :project_status, default: "funding"
      add :karma, :integer
      add :founder_id, references(:user, on_delete: :nothing)
      add :category_id, references(:category, on_delete: :nothing)

      timestamps()
    end

    create unique_index(:project, [:vision_name])
    create index(:project, [:founder_id])
    create index(:project, [:category_id])
  end
end
