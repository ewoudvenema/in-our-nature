defmodule CocuWeb.V1.CommunityController do
    use CocuWeb, :controller
    alias Cocu.Communities

    def get_communities(conn, %{"name" => name, "order" => order, "page" => page}) do
        offset = String.to_integer(page) * 12
        order = 
          case order do 
            "popularity" -> :popularity
            "newest" -> :newest
            "name" -> :name
            _ -> :none
          end
        
        community = Communities.get_by_order(name, order, 12, offset)
        
        # community =
        #     case params["order"] do
        #       "popularity" -> Communities.get_community_explorer_popularity(community_name)
        #       "newest" -> Communities.get_community_explorer_newest(community_name)
        #       "name" -> Communities.get_community_explorer_name(community_name)
        #       _ -> Communities.get_community_explorer(community_name)
        #     end  
        json(conn, community)
    end

    def deleteCommunity(conn, params) do
        community = Cocu.Repo.get!(Cocu.Communities.Community, params["id"])
        case Cocu.Repo.transaction(fn -> 
            Cocu.Communities.delete_community(community) end) do 
                {:ok, _} -> conn
                    |> json(200)
             _ -> conn
                |> send_resp(:bad_request, "")
        end
    end

    def get_project_photo(project_id) do
        pictures = Cocu.Medias.get_media_by_project(project_id)
        case pictures do
        [] -> "/images/universe_mask.jpg"
        [project_photo, _] -> project_photo[:image_path]
        _ -> nil
        end
    end

    def get_n_projects(conn, %{"community_id" => community_id, "page" => page}) do
        projects = Cocu.Projects.get_n_by_community_with_offset(String.to_integer(community_id), 4, 4 * String.to_integer(page))
        projects = Enum.map(projects, 
            fn (project = %{project_id: project_id}) ->
                Map.put(project, :image_path, get_project_photo(project_id))
            end
        )
        json(conn, %{projects: projects})
    end
end
