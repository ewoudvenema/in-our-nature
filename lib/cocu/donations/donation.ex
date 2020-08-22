defmodule Cocu.Donations.Donation do
  use Ecto.Schema
  import Ecto.Changeset
  alias Cocu.Donations.Donation


  schema "donation" do
    field :value, :float
    field :user_id, :id
    field :project_id, :id

    timestamps()
  end

  @doc false
  def changeset(%Donation{} = donation, attrs) do
    donation
    |> cast(attrs, [:value, :user_id, :project_id])
    |> validate_required([:value, :project_id])
  end
end
