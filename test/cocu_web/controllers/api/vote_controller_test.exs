defmodule CocuWeb.VoteApiTest do
  use CocuWeb.ConnCase

  alias Cocu.Categories
  alias Cocu.Users
  alias Cocu.Communities
  alias Cocu.Projects
  alias Cocu.Auth.Guardian

  def fixture(:vote) do
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
    %{user: user, project: project}
  end

  def guardian_login(conn, user) do
    bypass_through(conn, CocuWeb.Router, [:browser])
      |> get("/user")
      |> Guardian.Plug.sign_in(user)
      |> send_resp(200, "Flush the session yo")
      |> recycle()
  end

  describe "rate project" do
    setup [:create_project]

    test "insert rate", %{conn: conn, user: user, project: project} do
      assert project.karma == 0

      conn = guardian_login(conn, user)

      route = Enum.join(["/api/v1/vote/project/", project.id, "/rate/1"], "")

      response = post conn, route

      assert json_response(response, 200)

      {_, response_body} = Poison.decode(response.resp_body)
      assert response_body["project_rate"] == 1
      assert response_body["vote"] == 1
    end

    test "update rate", %{conn: conn, user: user, project: project} do
      assert project.karma == 0

      conn = guardian_login(conn, user)

      route = Enum.join(["/api/v1/vote/project/", project.id, "/rate/1"], "")

      response = post conn, route

      assert json_response(response, 200)

      {_, response_body} = Poison.decode(response.resp_body)
      assert response_body["project_rate"] == 1
      assert response_body["vote"] == 1

      route = Enum.join(["/api/v1/vote/project/", project.id, "/rate/-1"], "")

      response = post conn, route

      assert json_response(response, 200)

      {_, response_body} = Poison.decode(response.resp_body)
      assert response_body["project_rate"] == -1
      assert response_body["vote"] == -1
    end

    test "delete rate", %{conn: conn, user: user, project: project} do
      assert project.karma == 0

      conn = guardian_login(conn, user)

      route = Enum.join(["/api/v1/vote/project/", project.id, "/rate/1"], "")

      response = post conn, route

      assert json_response(response, 200)

      {_, response_body} = Poison.decode(response.resp_body)
      assert response_body["project_rate"] == 1
      assert response_body["vote"] == 1

      route = Enum.join(["/api/v1/vote/project/", project.id, "/rate/1"], "")

      response = post conn, route

      assert json_response(response, 200)

      {_, response_body} = Poison.decode(response.resp_body)
      assert response_body["project_rate"] == 0
      assert response_body["vote"] == 0
    end

  end

  defp create_project(_) do
    %{user: user, project: project} = fixture(:vote)
    {:ok, user: user, project: project}
  end
end
