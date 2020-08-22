defmodule Cocu.ProjectPosts.ProjectPost do
  use Ecto.Schema
  import Ecto.Changeset
  alias Cocu.ProjectPosts.ProjectPost


  schema "project_post" do
    field :user_id, :id
    field :project_id, :id
    field :post_id, :id

    timestamps()
  end

  @doc false
  def changeset(%ProjectPost{} = project_post, attrs) do
    project_post
    |> cast(attrs, [:user_id, :project_id, :post_id])
    |> validate_required([:user_id, :project_id, :post_id])
    |> foreign_key_constraint(:user_id)
    |> foreign_key_constraint(:project_id)
    |> foreign_key_constraint(:post_id)
  end
end
