defmodule Cocu.Repo.Migrations.CreateUser do
  use Ecto.Migration

  def change do
    execute("create type privileges_level as enum ('admin', 'user', 'banned')", "drop type privileges_level")

    create table(:user) do
      add :username, :string, null: false
      add :email, :string, null: false
      add :password, :string, null: false
      add :date_of_birth, :date, null: false
      add :name, :string, null: false
      add :privileges_level, :privileges_level, null: false
      add :picture_path, :string

      timestamps()
    end

    create unique_index(:user, [:username])
    create unique_index(:user, [:email])
  end
end
