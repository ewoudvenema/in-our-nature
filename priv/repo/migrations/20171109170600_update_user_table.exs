defmodule Cocu.Repo.Migrations.UpdateUserTable do
  use Ecto.Migration

  def change do
    alter table(:user) do
      modify :date_of_birth, :date, null: true
      modify :name, :string, null: true
    end
  end
end
