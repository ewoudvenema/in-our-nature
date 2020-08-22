defmodule CocuWeb.CommunityController do
  use CocuWeb, :controller

  alias Cocu.Communities
  alias Cocu.Communities.Community
  alias Cocu.CommunityPosts
  alias CocuWeb.UploadS3

  def index(conn, _params) do
    community = Communities.list_community()
    render(conn, "index.html", community: community, page_title: "Search for Communities")
  end

  def new(conn, _params) do
    changeset = Communities.change_community(%Community{})
    render(conn, "new.html", changeset: changeset, page_title: "Create Community")
  end

  def create(conn, %{"community" => community_params}) do
    updated_params =
      case Map.has_key?(community_params, "picture_path") do
        true -> UploadS3.insertImageForUser(community_params["picture_path"], community_params)
        false -> community_params
      end
    case Communities.create_community(updated_params) do
      {:ok, community} ->
        conn
        |> put_flash(:info, "Community created successfully.")
        |> redirect(to: community_path(conn, :show, community))
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset, page_title: "Create Community")
    end
  end

  def show(conn, %{"id" => id}) do
    community = Communities.get_community!(id)
    community_projects = Cocu.Projects.get_n_by_community_with_offset(id, 4, 0)
    community_posts = CommunityPosts.get_n_posts_with_offset(id, 10, 0)
    render(conn, "show.html", community: community, projects: community_projects, posts: community_posts, page_title: community.name)
  end

  def edit(conn, %{"id" => id}) do
    community = Communities.get_community!(id)
    changeset = Communities.change_community(community)
    render(conn, "edit.html", community: community, changeset: changeset, page_title: "Edit Community")
  end

  def update(conn, %{"id" => id, "community" => community_params}) do
    community = Communities.get_community!(id)

    case Communities.update_community(community, community_params) do
      {:ok, community} ->
        conn
        |> put_flash(:info, "Community updated successfully.")
        |> redirect(to: community_path(conn, :show, community))
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", community: community, changeset: changeset, page_title: "Edit Community")
    end
  end

  def delete(conn, %{"id" => id}) do
    community = Communities.get_community!(id)
    {:ok, _community} = Communities.delete_community(community)

    conn
    |> put_flash(:info, "Community deleted successfully.")
    |> redirect(to: community_path(conn, :index))
  end
end
