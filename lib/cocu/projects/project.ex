defmodule Cocu.Projects.Project do
  use Ecto.Schema
  import Ecto.Changeset
  alias Cocu.Projects.Project

  schema "project" do
    field :benefits, :string
    field :current_fund, :float
    field :fund_asked, :float
    field :fund_limit_date, :date
    field :karma, :integer, default: 0
    field :planning, :string
    field :state, :string
    field :vision, :string
    field :vision_name, :string
    field :website, :string
    field :founder_id, :id
    field :category_id, :id
    field :community_id, :id
    field :location, :string
    field :impact, :string
    field :stripe_acc, :string
    field :deleted, :boolean, default: false
    field :accepted, :boolean, default: false
    timestamps()
  end

  @doc false
  def changeset(%Project{} = project, attrs) do
    project
    |> cast(attrs, [:deleted, :impact, :location, :vision_name, :planning, :vision, :benefits, :fund_asked, :fund_limit_date, :website, :current_fund, :state, :karma, :category_id, :community_id, :founder_id, :stripe_acc, :accepted])
    |> validate_required([:impact, :location, :vision_name, :planning, :vision, :benefits, :fund_asked, :fund_limit_date, :category_id, :founder_id, :community_id])
    |> foreign_key_constraint(:category_id)
    |> foreign_key_constraint(:community_id)
    |> foreign_key_constraint(:founder_id)
    |> validate_number(:fund_asked, greater_than: 0)
    |> validate_inclusion(:state, ["presentation", "funding", "creation"])
    |> validate_inclusion(:impact, ["regional", "national", "international", "global"])
    |> unique_constraint(:vision_name)
  end
end
