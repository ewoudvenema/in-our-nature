defmodule CocuWeb.V1.ProjectController do

  use CocuWeb, :controller

  alias Cocu.Repo
  alias Cocu.Projects
  alias Cocu.Donations
  alias Cocu.Users

  def updateProjectState(conn, params) do
    project = Projects.get_project!(params["id"])
    case Guardian.Plug.current_resource(conn).id == project.founder_id do
      false ->
        json(conn, %{message: "Unauthorized access."})
      true ->
        project = Repo.get!(Cocu.Projects.Project, params["id"])
        project = Ecto.Changeset.change project, state: params["state"]

        case Enum.member?(["presentation", "funding", "creation"], params["state"]) do
          true ->
            case Repo.update(project) do
              {:ok, _struct} -> json(conn, %{message: "Success"})
              _ -> json(conn, %{message: "Database error"})
            end
          _ -> json(conn, %{message: "Invalid project state"})
        end
    end
  end

  def updateProjectDeleted(conn, params) do
    project = Repo.get!(Cocu.Projects.Project, params["id"])
    case Guardian.Plug.current_resource(conn).id == project.founder_id do
      true ->
        project = Ecto.Changeset.change project, deleted: true
        case Repo.update(project) do
          {:ok, _struct} ->
            json(conn, %{message: "Success"})
          _ -> json(conn, %{message: "Database error"})
        end
      false ->
        json(conn, %{message: "Unauthorized user."})
    end
  end


  def connect(conn, params) do
    case Integer.parse(params["id"], 10) do
      :error ->
        conn
        |> send_resp(:bad_request, "No id sent in parameters")
      {id, _} ->
        put_session(conn, :connection_project_id, id)
        |> send_resp(:ok, "")
    end
  end

  def donate(conn, params) do
    project_id = params["project_id"]

    case project_id do
      nil ->
        conn
        |> json("Project ID must be provided")
      _ ->
        project = Projects.get_project(project_id)

        case project.stripe_acc do
          nil -> conn
                 |> json("The destination does not have a Stripe account associated")
          _ ->
            case params["amount"] == nil || params["currency"] == nil || params["token"]["id"] == nil do
              true ->
                conn
                |> json("Missing parameters")
              false ->
                current_user_id = case Guardian.Plug.current_resource(conn) do
                  nil -> nil
                  user -> user.id
                end

                body = %{
                  "amount" => params["amount"],
                  "currency" => params["currency"],
                  "source" => params["token"]["id"],
                  "description" => "COCU: Donation to project \"" <> project.vision_name <> "\"",
                  "destination" => project.stripe_acc,
                  "metadata[user_id]" =>
                    case current_user_id do
                      nil -> -1
                      current_user_id -> current_user_id
                    end,
                  "metadata[project_id]" => project.id
                }

                options = [
                  body: URI.encode_query(body),
                  basic_auth: {Application.get_env(:cocu, :stripe_secret_key), ""}
                ]

                resp = HTTPotion.post("https://api.stripe.com/v1/charges", options)
                {:ok, response} = Poison.decode(resp.body)

                case response["status"] do
                  "pending" ->
                    conn
                    |> json("Donation pending")
                  "succeeded" ->
                    {donation_amount, ""} = Integer.parse(params["amount"])
                    donation_amount = donation_amount / 100
                    Donations.create_donation(
                      %{project_id: project_id, value: donation_amount, user_id: current_user_id}
                    )

                    conn
                    |> json("Donation successful")
                  _ ->
                    conn
                    |> json("Donation failed")
                end
            end
        end
    end
  end

  def getBackers(conn, params) do
    body =
      case params["lastCharge"] do
        nil ->
          %{}
        last_charge ->
          %{
            "starting_after" => last_charge
          }
      end

    case params["projectId"] do
      nil ->
        conn
        |> json([])
      project_id ->
        options = [
          body: URI.encode_query(body),
          basic_auth: {Application.get_env(:cocu, :stripe_secret_key), ""}
        ]

        resp = HTTPotion.get('https://api.stripe.com/v1/charges?limit=100&status=succeeded', options)

        {_, response_body} = Poison.decode(resp.body)

        acc = Enum.reduce response_body["data"], [], fn charge, acc ->
          case charge["status"] do
            "succeeded" ->
              metadata = charge["metadata"]
              charge_project_id = metadata["project_id"]
              case metadata["project_id"] do
                nil -> acc
                charge_project_id ->
                  case String.equivalent?(charge_project_id, project_id) do
                    true ->
                      case metadata do
                        %{"user_id" => user_id} ->
                          case user_id do
                            "-1" ->
                              [%{id: -1, value: charge["source"]["amount"] / 100, date: charge["created"]} | acc]
                            _ ->
                              user = Users.get_user!(user_id)
                              [
                                %{
                                  data_id: charge["id"],
                                  id: user_id,
                                  value: charge["source"]["amount"] / 100,
                                  name: user.name,
                                  photo: user.picture_path,
                                  date: charge["created"]
                                } | acc
                              ]
                          end
                        _ -> acc
                      end
                    _ -> acc
                  end
              end
            _ -> acc
          end
        end
        conn
        |> json(acc)
    end
  end
end
