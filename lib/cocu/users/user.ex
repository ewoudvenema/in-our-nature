defmodule Cocu.Users.User do
  use Ecto.Schema
  import Ecto.Changeset
  alias Cocu.Users.User


  schema "user" do
    field :date_of_birth, :date
    field :email, :string
    field :name, :string
    field :password, :string
    field :picture_path, :string
    field :privileges_level, :string, default: "user"
    field :description, :string
    field :deleted, :boolean, default: false

    timestamps()
  end

  @doc false
  def changeset(%User{} = user, attrs) do
    user
    |> cast(attrs, [:email, :password, :date_of_birth, :name, :privileges_level, :picture_path, :description, :deleted])
    |> validate_required([:name, :email, :password])
    |> validate_inclusion(:privileges_level, ["user", "admin", "banned"])
    |> unique_constraint(:email)
    |> put_pass_hash()
  end

  defp put_pass_hash(%Ecto.Changeset{valid?: true, changes: %{password: password}} = changeset) do
    change(changeset, password: Bcrypt.hash_pwd_salt(password))
  end
  defp put_pass_hash(changeset), do: changeset

end
