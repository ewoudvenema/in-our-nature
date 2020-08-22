defmodule Cocu.Medias.Media do
  use Ecto.Schema
  import Ecto.Changeset
  alias Cocu.Medias.Media


  schema "media" do
    field :image_path, :string
    field :project_id, :id

    timestamps()
  end

  @doc false
  def changeset(%Media{} = media, attrs) do
    media
    |> cast(attrs, [:image_path, :project_id])
    |> validate_required([:image_path])
    |> unique_constraint(:image_path)
  end
end
