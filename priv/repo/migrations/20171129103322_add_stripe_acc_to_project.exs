defmodule Cocu.Repo.Migrations.AddStripeAccToProject do
  use Ecto.Migration

  def change do
    alter table(:project) do
      add :stripe_acc, :string
    end
  end
end
