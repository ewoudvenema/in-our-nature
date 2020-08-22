defmodule CocuWeb.ExploreView do
    use CocuWeb, :view
    alias Cocu.Projects
    alias Cocu.Categories
    alias Cocu.CommunityUsers
  
    def get_projects(state, impact, categories, communities, name) do
      Projects.get_projects_by_filters(state, impact, categories, communities, name, :none)
    end
  
    def get_project_photos(id) do
      Projects.get_project_photos(id)
    end
  
    def get_categories() do
      Categories.list_category() 
    end
  
    def get_communities(id) do
      CommunityUsers.get_followed_communities(id)
    end

    def get_all_projects(list_state, list_impact, list_categories, list_communities, name, order) do
      
      listing_order = case order do
        "nearing-deadline" -> :nearing_deadline
        "popularity" -> :popularity
        "newest" -> :newest
        "most-funded" -> :most_funded
        _ -> :none
      end

      new_name = "%" <> name <> "%"

      Projects.get_projects_by_filters(list_state, list_impact, list_categories, list_communities, new_name, listing_order, 6, 0)
    end
  end
  