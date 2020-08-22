defmodule Cocu.Repo.Migrations.AddVoteUniquePairConstraint do
  use Ecto.Migration

  def change do
    create unique_index(:vote, [:user_id, :project_id], name: "unique_user_id_project_vote")
  end
end
