defmodule CocuWeb.V1.ManageController do
    use CocuWeb, :controller
    alias Cocu.Communities
    alias Cocu.Projects
    alias Cocu.Repo

    def getCommunities(conn, params) do
        community = Communities.get_communities_user(Guardian.Plug.current_resource(conn).id)
        json(conn, community)
    end

    def getCommunitiesProjects(conn, params) do
        community_id = String.to_integer(params["id"])
        projects = Projects.get_projects_by_community(community_id)
        json(conn, projects)
    end

    def updateProjectAcceptance(conn, params) do
        project_id = String.to_integer(params["id"])
        project = Repo.get!(Cocu.Projects.Project, project_id)
        project = Ecto.Changeset.change project, accepted: true

        case Repo.update(project) do
            {:ok, _struct} -> json(conn, %{message: "Success"})
            _ -> json(conn, %{message: "Database error"})
        end
    end

    def deleteProject(conn, params) do
        project = Repo.get!(Cocu.Projects.Project, params["id"])
        project = Ecto.Changeset.change project, deleted: true
        case Repo.update(project) do
          {:ok, _struct} -> 
            json(conn, %{message: "Success"})
          _ -> json(conn, %{message: "Database error"})
        end
    end
end
