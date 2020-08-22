defmodule CocuWeb.ProjectPostApiTest do
  use CocuWeb.ConnCase

  alias Cocu.Categories
  alias Cocu.Posts
  alias Cocu.Users
  alias Cocu.Projects
  alias Cocu.Communities
  alias Cocu.Auth.Guardian
  alias Cocu.ProjectPosts

  def fixture(:project_post) do
      {:ok, category} = Categories.create_category(%{name: "some category"})
    {:ok, user} = Users.create_user(
      %{
        date_of_birth: ~D[2010-04-17],
        email: "some email",
        name: "some name",
        password: "some password",
        picture_path: "some picture_path",
        privileges_level: "user",
        username: "some username"
      }
    )
    {:ok, community} = Communities.create_community(%{description: "some description", is_group: true, name: "some name", picture_path: "some picture_path", founder_id: user.id})
    {:ok, project} = Projects.create_project(
      %{
        benefits: "some benefits",
        current_fund: 120.5,
        fund_asked: 120.5,
        fund_limit_date: ~D[2010-04-17],
        planning: "some planning",
        state: "funding",
        vision: "some vision",
        vision_name: "some vision_name",
        website: "some website",
        category_id: category.id,
        founder_id: user.id,
        community_id: community.id,
        location: "Porto",
        impact: "global"
      }
    )
    {:ok, post} = Posts.create_post(%{content: "Some Post", title: "Post Title"})
    {:ok, project_post} = ProjectPosts.create_project_post(%{user_id: user.id, project_id: project.id, post_id: post.id})

    %{user: user, project: project, post: post, project_post: project_post}
  end

  def guardian_login(conn, user) do
    bypass_through(conn, CocuWeb.Router, [:browser])
      |> get("/user")
      |> Guardian.Plug.sign_in(user)
      |> send_resp(200, "Flush the session yo")

  end

  describe "project post" do
    setup [:project_post]

    test "add project post", %{conn: conn, user: user, post: post, project: project} do

        conn = guardian_login(conn, user)
        route = Enum.join(["/api/v1/project_post/new/?post_title=", URI.encode(post.title), "&post_content=", URI.encode(post.content), "&user_id=", user.id, "&project_id=", project.id],"")

        response = post conn, route

        assert json_response(response, 200)

        {_, response_body} = Poison.decode(response.resp_body)
        assert response_body["status"] == "ok"

    end

    test "edit project post", %{conn: conn, user: user, post: post, project: project} do

        conn = guardian_login(conn, user)
        route = Enum.join(["/api/v1/project_post/edit/", post.id ,"?post_title=", URI.encode(post.title), "&post_content=", URI.encode(post.content)],"")

        response = put conn, route

        assert json_response(response, 200)

        {_, response_body} = Poison.decode(response.resp_body)
        assert response_body["status"] == "ok"

    end

    test "delete project post", %{conn: conn, user: user, post: post, project: project} do

        conn = guardian_login(conn, user)
        route = Enum.join(["/api/v1/project_post/delete/", post.id],"")

        response = delete conn, route

        assert json_response(response, 200)

        {_, response_body} = Poison.decode(response.resp_body)
        assert response_body["status"] == "ok"

    end
    
    test "get by page project post", %{conn: conn, user: user, post: post, project: project} do

        conn = guardian_login(conn, user)
        route = Enum.join(["api/v1/project_post/get_page/?page=",0, "&project_id=", project.id],"")

        response = get conn, route


        {_, response_body} = Poison.decode(response.resp_body)

        assert Enum.empty?(response_body["posts"]) == false

    end

  end


  defp project_post(_) do
    %{user: user, project: project, post: post, project_post: project_post} = fixture(:project_post)
    {:ok, user: user, project: project, post: post, project_post: project_post}
  end
end
