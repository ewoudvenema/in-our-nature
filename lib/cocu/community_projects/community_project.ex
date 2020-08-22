defmodule Cocu.CommunityProjects.CommunityProject do
  use Ecto.Schema
  import Ecto.Changeset
  alias Cocu.CommunityProjects.CommunityProject


  schema "community_project" do
    field :project_id, :id
    field :community_id, :id

    timestamps()
  end

  @doc false
  def changeset(%CommunityProject{} = community_project, attrs) do
    community_project
    |> cast(attrs, [:project_id, :community_id])
    |> validate_required([:project_id, :community_id])
  end
end
