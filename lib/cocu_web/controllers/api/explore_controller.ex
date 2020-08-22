defmodule CocuWeb.V1.ExploreController do
    use CocuWeb, :controller
    alias Cocu.Projects

    def getProjects(conn, params) do
        
        list_state = 
            case params["state"] do
                nil -> []
                _ -> params["state"]
            end

        list_impact = 
            case params["impact"] do
                nil -> []
                _ -> params["impact"]
            end

        list_categories = 
            case params["category"] do
                nil -> []
                _ -> Enum.map(params["category"], fn(x) -> String.to_integer(x) end)
            end

        list_communities = 
            case params["community"] do
                nil -> []
                _ -> Enum.map(params["community"], fn(x) -> String.to_integer(x) end)
            end

        name = params["name"]
        
      listing_order = 
        case params["order"] do
            "nearing-deadline" -> :nearing_deadline
            "popularity" -> :popularity
            "newest" -> :newest
            "most-funded" -> :most_funded
            _ -> :none
        end

        page =
            case params["page"] do
                nil -> 0
                _ -> params["page"]
            end

        offset = 6 * String.to_integer(page)
        projects = Projects.get_projects_by_filters(list_state, list_impact, list_categories, list_communities, name, listing_order, 7, offset)
        json(conn, projects)
    end

    def getAllProjects(conn) do
        projects = Projects.list_project()
        json(conn, projects)
    end

end
