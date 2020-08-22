defmodule Cocu.Repo.Migrations.UpdateUser do
  use Ecto.Migration

  def change do
    alter table(:user) do
      add :description, :string, size: 100
    end
  end
end
