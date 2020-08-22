defmodule Cocu.Repo.Migrations.UpdateUserTableUsername do
  use Ecto.Migration

  def change do
    alter table(:user) do
      modify :name, :string, null: false
      remove :username
    end
  end
end
