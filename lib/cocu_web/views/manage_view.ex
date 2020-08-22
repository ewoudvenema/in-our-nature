defmodule CocuWeb.ManageView do
    use CocuWeb, :view
    alias Cocu.Communities

    def get_communities_by_user_id(id) do
      Communities.get_communities_by_user(id)
    end
    
  end
  