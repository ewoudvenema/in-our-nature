Application.start :hound

defmodule CocuWeb.ProjectViewTest do
  use ExUnit.Case

  alias Cocu.Repo

  setup do
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(Repo)

    # TODO: Change to manual mode so that tests can be run asynchronously
    Ecto.Adapters.SQL.Sandbox.mode(Repo, {:shared, self()})

    CocuWeb.InitializeDatabase.init()
  end
end
