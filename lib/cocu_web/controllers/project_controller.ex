defmodule CocuWeb.ProjectController do
  use CocuWeb, :controller
  require Logger

  alias Cocu.Projects
  alias Cocu.Projects.Project
  alias Cocu.ProjectPosts
  alias Cocu.Communities
  alias Cocu.Categories
  alias CocuWeb.MediaController
  alias CocuWeb.UploadS3
  alias Cocu.Medias
  alias Cocu.Votes
  alias CocuWeb.Router

  def index(conn, _params) do
    project = Projects.list_project()
    render(conn, "index.html", project: project)
  end

  def new(conn, _params) do
    changeset = Projects.change_project(%Project{})
    enum = Projects.get_all_impact()
    enum_impact = Enum.concat(enum)
    categories = Categories.list_category()
    render(
      conn,
      "new.html",
      changeset: changeset,
      categories: categories,
      impacts: enum_impact,
      page_title: "Create Project"
    )
  end

  def create(conn, %{"project" => project_params}) do
    categories = Categories.list_category()
    enum = Projects.get_all_impact()
    enum_impact = Enum.concat(enum)
    case Projects.create_project(project_params) do
      {:ok, project} ->
        for n <- [1, 2, 3, 4], do: createImage(conn, project_params, Enum.join(["project_picture_", n], ""), project.id)
        conn
        |> put_flash(:info, "Project created successfully.")
        |> redirect(to: project_path(conn, :show, project))
      {:error, %Ecto.Changeset{} = changeset} ->
        render(
          conn,
          "new.html",
          changeset: changeset,
          categories: categories,
          impacts: enum_impact,
          page_title: "Create Project"
        )
    end
  end

  def deleteProjectImageParams(params) do
    update_params = Map.delete(params, "project_picture_1")
    update_params = Map.delete(update_params, "project_picture_2")
    update_params = Map.delete(update_params, "project_picture_3")
    Map.delete(update_params, "project_picture_4")
  end

  def createImage(conn, project_params, picture_path, project_id) do
    if Map.has_key?(project_params, picture_path) do
      insertProjectImages(conn, project_id, project_params[picture_path])
    end
  end

  def insertProjectImages(conn, id, picture_path_params) do
    image_path = UploadS3.insertImage(picture_path_params)
    media_changeset = %{
      "media" => %{
        "image_path" => image_path,
        "project_id" => id
      }
    }
    MediaController.create(conn, media_changeset)
  end

  def disconnect_stripe_acc(conn, %{"id" => project_id}) do
    {project_id, _} = Integer.parse(project_id)

    case project_id do
      nil ->
        render(conn, "403.html")
      project_id ->
        project = Projects.get_project!(project_id)
        project_founder = project.founder_id

        case Guardian.Plug.current_resource(conn).id do
          project_founder ->
            {:ok, project} = Projects.update_project(project, %{stripe_acc: nil})

            conn
            |> put_flash(:info, "Account disconnected successfully")
            |> redirect(to: project_path(conn, :show, project_id))
          _ ->
            render(conn, "401.html")
        end
    end
  end

  def connect_stripe_acc(conn, params) do
    project_id = get_session(conn, :connection_project_id)

    if Guardian.Plug.current_resource(conn) == nil do
      render(conn, "403.html")
    end

    case params["code"] do
      nil ->
        conn
        |> put_flash(:info, "Account connection failed")
        |> redirect(to: project_path(conn, :show, project_id))
      auth_code ->
        body = %{
          "code" => params["code"],
          "grant_type" => "authorization_code"
        }

        options = [
          body: URI.encode_query(body),
          basic_auth: {Application.get_env(:cocu, :stripe_secret_key), ""}
        ]

        resp = HTTPotion.post("https://connect.stripe.com/oauth/token", options)

        case Poison.decode resp.body do
          {:error, error} ->
            conn
            |> json(body)

          {:ok, body} ->
            stripe_acc = body["stripe_user_id"]

            case stripe_acc do
              nil ->
                conn
                |> put_flash(:info, "Account connection failed")
                |> redirect(to: project_path(conn, :show, project_id))
              stripe_acc ->
                update_project_stripe_account(project_id, stripe_acc)
                conn
                |> put_flash(:info, "Account connected successfully")
                |> redirect(to: project_path(conn, :show, project_id))
            end
        end
    end
  end

  defp update_project_stripe_account(project_id, stripe_acc) do
    project = Projects.get_project(project_id)
    {:ok, project} = Projects.update_project(project, %{stripe_acc: stripe_acc})
  end

  defp construct_url_from_struct(%URI{host: host, port: port, scheme: scheme}) do
    case host do
       "localhost" -> scheme <> "://" <> host <> ":" <> Integer.to_string(port)
       _ -> scheme <> "://" <> host
    end
  end

  def show(conn, %{"id" => id} = params) do
    {project_id, _} = Integer.parse(id)
    project = Projects.get_project!(project_id)
    photos = Projects.get_project_photos(project_id)

    case project.deleted do
      true ->
        conn
        |> put_flash(:warning, "Project was deleted.")
        |> redirect(to: "/")
      false ->
        userId =
          case Guardian.Plug.current_resource(conn) do
            nil -> -1
            _ -> Guardian.Plug.current_resource(conn).id
          end
        [founder_id | _] = Communities.get_community_founder_by_project(project.community_id)

        case project.accepted || founder_id.community_founder_id == userId || project.founder_id == userId do
          true ->
            project_posts = ProjectPosts.get_n_by_project_with_offset(id, 10, 0)
            vote =
              case Guardian.Plug.current_resource(conn) == nil do
                true -> nil
                false ->
                  user_id = Guardian.Plug.current_resource(conn).id
                  Votes.get_project_user_vote(project_id, user_id)
              end

            case conn.query_params["code"] do
              nil -> nil
              authorization_code -> Stripe.Connect.oauth_token_callback(authorization_code)
            end

            render(
              conn,
              "show.html",
              project: project,
              vote: vote,
              posts: project_posts,
              photos: photos,
              stripe_button_url: Stripe.Connect.generate_button_url(
                Plug.CSRFProtection.get_csrf_token(),
                construct_url_from_struct(CocuWeb.Endpoint.struct_url()) <> "/project/connect"
              ),
              ajax_url: construct_url_from_struct(CocuWeb.Endpoint.struct_url()) <> "/api/v1/project/connect/" <> Integer.to_string(project_id, 10),
              is_owner:
                Guardian.Plug.current_resource(conn) != nil && Guardian.Plug.current_resource(
                  conn
                ).id == project.founder_id
            )
          false ->
            put_flash(conn, :warning, "Project isn't available.")
            |> redirect(to: "/")
        end
    end
  end

  def edit(conn, %{"id" => id}) do
    project = Projects.get_project!(id)
    case Guardian.Plug.current_resource(conn) do
      nil ->
        conn
        |> put_flash(:info, "You must loggin to modify a project.")
        |> redirect(to: user_path(conn, :index))
      user ->
        case project.founder_id == user.id do
          true ->
            enum = Projects.get_all_impact()
            enum_impact = Enum.concat(enum)
            categories = Categories.list_category()
            changeset = Projects.change_project(project)
            render(
              conn,
              "edit.html",
              project: project,
              changeset: changeset,
              categories: categories,
              impacts: enum_impact
            )
          false ->
            conn
            |> put_flash(:info, "You cannot modify this project")
            |> redirect(to: user_path(conn, :edit, user))
        end
    end
  end

  def update(conn, %{"id" => id, "project" => project_params}) do
    project = Projects.get_project!(id)
    case project.founder_id == Guardian.Plug.current_resource(conn).id do
      true ->
        categories = Categories.list_category()
        if Map.has_key?(project_params, "project_picture_1") do
          current_images = Medias.get_media_by_project(String.to_integer(id))
          Enum.each current_images, fn image ->
            UploadS3.deleteImageFromS3(image.image_path)
            Medias.delete_media_by_project_id(image.project_id)
          end
          for n <- [1, 2, 3, 4], do: createImage(conn, project_params, Enum.join(["project_picture_", n], ""), id)
        end

        case Projects.update_project(project, project_params) do
          {:ok, project} ->
            conn
            |> put_flash(:info, "Project updated successfully.")
            |> redirect(to: project_path(conn, :show, project))
          {:error, %Ecto.Changeset{} = changeset} ->
            enum = Projects.get_all_impact()
            enum_impact = Enum.concat(enum)
            render(
              conn,
              "edit.html",
              project: project,
              changeset: changeset,
              categories: categories,
              impacts: enum_impact
            )
        end
      false ->
        conn
        |> put_flash(:info, "You cannot modify this project")
        |> redirect(to: user_path(conn, :edit, Guardian.Plug.current_resource(conn)))
    end

  end

  def delete(conn, %{"id" => id}) do
    project = Projects.get_project!(id)
    case project.founder_id == Guardian.Plug.current_resource(conn).id do
      true ->
        {:ok, _project} = Projects.delete_project(project)
        conn
        |> put_flash(:info, "Project deleted successfully.")
        |> redirect(to: "/")
      false ->
        conn
        |> put_flash(:info, "You cannot modify this project")
        |> redirect(to: user_path(conn, :edit, Guardian.Plug.current_resource(conn)))
    end
  end
end
