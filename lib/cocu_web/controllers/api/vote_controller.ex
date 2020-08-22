defmodule CocuWeb.V1.VoteController do
    use CocuWeb, :controller
    alias Cocu.Votes
    alias Cocu.Projects

    def userRateProject(conn, params) do
      user_id = Guardian.Plug.current_resource(conn).id
      {project_id, _} = Integer.parse(params["project_id"])
      {rate, _} = Integer.parse(params["rate"])

      vote = Votes.get_project_user_vote(project_id, user_id)

      positive =
        case rate do
          1 -> true
          -1 -> false
        end

      case vote != nil do #if there is already a vote for this project
        true ->
          voteObj = Votes.get_vote!(vote.id)
          case positive == vote.positive do
            true ->
              case Votes.delete_vote(voteObj) do
                {:ok, _} ->
                  project = Projects.get_project!(project_id)
                  json(conn, %{vote: 0, project_rate: project.karma})
                false -> json(conn, %{error: "Error deleting"})
              end
            false ->
              case Votes.update_vote(voteObj, %{positive: positive}) do
                {:ok, _} ->
                  project = Projects.get_project!(project_id)
                  json(conn, %{vote: rate, project_rate: project.karma})
                false -> json(conn, %{error: "Error updating"})
              end
          end
        false  ->
          case Votes.create_vote(%{positive: positive, user_id: user_id, project_id: project_id}) do
            {:ok, _} ->
              project = Projects.get_project!(project_id)
              json(conn, %{vote: rate, project_rate: project.karma})
            false ->
              json(conn, %{error: "Error creating"})
          end
      end
    end

end
