defmodule Cocu.ProjectComments.ProjectComment do
  use Ecto.Schema
  import Ecto.Changeset
  alias Cocu.ProjectComments.ProjectComment


  schema "project_comment" do
    field :user_id, :id
    field :project_id, :id
    field :post_id, :id

    timestamps()
  end

  @doc false
  def changeset(%ProjectComment{} = project_comment, attrs) do
    project_comment
    |> cast(attrs, [:user_id, :project_id, :post_id])
    |> validate_required([:user_id, :project_id, :post_id])
    |> foreign_key_constraint(:user_id)
    |> foreign_key_constraint(:project_id)
    |> foreign_key_constraint(:post_id)
  end
end
