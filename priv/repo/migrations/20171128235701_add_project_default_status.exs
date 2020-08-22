defmodule Cocu.Repo.Migrations.AddProjectDefaultStatus do
  use Ecto.Migration

  def change do
    alter table(:project) do
      modify :state, :string, default: "presentation"
    end
  end
end
