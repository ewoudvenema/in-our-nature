defmodule Cocu.Repo.Migrations.DeleteUser do
  use Ecto.Migration

  def change do
    alter table(:user) do
      add :deleted, :boolean, default: false
    end
  end
end
