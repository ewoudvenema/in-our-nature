defmodule CocuWeb.FeatureCase do
  use ExUnit.CaseTemplate

  using do
    quote do
      #use Wallaby.DSL

      alias Cocu.Repo
      import Ecto
      import Ecto.Changeset
      import Ecto.Query

      import CocuWeb.Router.Helpers
    end
  end

  setup tags do
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(Cocu.Repo)

    unless tags[:async] do
      Ecto.Adapters.SQL.Sandbox.mode(Cocu.Repo, {:shared, self()})
    end

    #metadata = Phoenix.Ecto.SQL.Sandbox.metadata_for(Cocu.Repo, self())
    #{:ok, session} = Wallaby.start_session(metadata: metadata)

    #data = CocuWeb.InitializeDatabase.init()
    #session_data = Map.merge(session, data)

    #{:ok, session: session_data}
    {:ok, session: %{}}
  end
end
