defmodule Cocu.Votes.Vote do
  use Ecto.Schema
  import Ecto.Changeset
  alias Cocu.Votes.Vote


  schema "vote" do
    field :positive, :boolean, default: false
    field :user_id, :id
    field :project_id, :id

    timestamps()
  end

  @doc false
  def changeset(%Vote{} = vote, attrs) do
    vote
    |> cast(attrs, [:positive, :user_id, :project_id])
    |> validate_required([:positive, :user_id, :project_id])
    |> foreign_key_constraint(:user_id)
    |> foreign_key_constraint(:project_id)
  end
end
