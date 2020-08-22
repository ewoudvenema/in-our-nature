defmodule Cocu.Repo.Migrations.CreateCommunity do
  use Ecto.Migration

  def change do
    create table(:community) do
      add :founder_id, references(:user, on_delete: :nothing)
      add :name, :string, null: false
      add :is_group, :boolean, null: false, default: false
      add :description, :string
      add :picture_path, :string, default: "universe_mask.jpg"

      timestamps()
    end

    create unique_index(:community, [:name])
    create index(:community, [:founder_id])
  end
end
