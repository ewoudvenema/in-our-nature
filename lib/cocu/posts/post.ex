defmodule Cocu.Posts.Post do
  use Ecto.Schema
  import Ecto.Changeset
  alias Cocu.Posts.Post


  schema "post" do
    field :content, :string
    field :title, :string

    timestamps()
  end

  @doc false
  def changeset(%Post{} = post, attrs) do
    post
    |> cast(attrs, [:title, :content])
    |> validate_required([:title, :content])
  end
end
