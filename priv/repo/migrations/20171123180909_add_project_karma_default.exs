defmodule Cocu.Repo.Migrations.AddProjectKarmaDefault do
  use Ecto.Migration

  def change do
      alter table(:project) do
      modify :karma, :integer, default: 0
    end
  end
end
