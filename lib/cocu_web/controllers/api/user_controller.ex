defmodule CocuWeb.V1.UserController do

  use CocuWeb, :controller

  alias Cocu.Repo

  def updateUserDeleted(conn, params) do

    user = Repo.get!(Cocu.Users.User, params["id"])
    user = Ecto.Changeset.change user, deleted: true

    case Repo.update(user) do
      {:ok, _struct} -> json(conn, %{message: "Success"})
      _ -> json(conn, %{message: "Database error"})
    end
  end
end
