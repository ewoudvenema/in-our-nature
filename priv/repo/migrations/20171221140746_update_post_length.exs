defmodule Cocu.Repo.Migrations.UpdatePostLength do
  use Ecto.Migration

  def change do
    alter table(:post_reply) do
      modify :content, :string, null: false, size: 4096
    end
  end
end
