defmodule Cocu.Categories.Category do
  use Ecto.Schema
  import Ecto.Changeset
  alias Cocu.Categories.Category


  schema "category" do
    field :name, :string

    timestamps()
  end

  @doc false
  def changeset(%Category{} = category, attrs) do
    category
    |> cast(attrs, [:name])
    |> validate_required([:name])
    |> unique_constraint(:name)
  end
end
