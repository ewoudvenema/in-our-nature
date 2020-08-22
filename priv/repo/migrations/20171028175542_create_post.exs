defmodule Cocu.Repo.Migrations.CreatePost do
  use Ecto.Migration

  def change do
    create table(:post) do
      add :title, :string, null: false
      add :content, :string, null: false

      timestamps()
    end

  end
end
