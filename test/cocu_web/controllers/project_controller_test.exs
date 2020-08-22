defmodule CocuWeb.ProjectControllerTest do
  use CocuWeb.ConnCase

  alias Cocu.Projects
  alias Cocu.Categories
  alias Cocu.Users
  alias Cocu.Communities
  alias Cocu.Auth.Guardian

  @invalid_attrs %{
    benefits: nil,
    current_fund: nil,
    fund_asked: -50,
    fund_limit_date: nil,
    karma: nil
  }
  @community_attrs %{description: "some description", is_group: true, name: "some name", picture_path: "some picture_path"}


  def fixture(:project) do
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
    {:ok, community} = Communities.create_community(Map.merge(@community_attrs, %{founder_id: user.id}))
    {:ok, project} = Projects.create_project(
      %{
        benefits: "some benefits",
        current_fund: 120.5,
        fund_asked: 120.5,
        fund_limit_date: ~D[2010-04-17],
        karma: 42,
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
    project
  end

  def guardian_login(conn, user) do
    bypass_through(conn, CocuWeb.Router, [:browser])
      |> get("/user")
      |> Guardian.Plug.sign_in(user)
      |> send_resp(200, "Flush the session yo")
      |> recycle()
  end

  describe "new project" do
    test "renders form", %{conn: conn} do
      {:ok, user} = Users.create_user(%{date_of_birth: ~D[2010-04-17], email: "some email",name: "some name", password: "some password", picture_path: "some picture_path", privileges_level: "user", username: "some username"})
      conn = guardian_login(conn, user)
      conn = get conn, project_path(conn, :new)
      assert html_response(conn, 200) =~ "CREATE PROJECT"
    end
  end

  describe "create project" do
    test "redirects to show when data is valid", %{conn: conn} do
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
      {:ok, community} = Communities.create_community(Map.merge(@community_attrs, %{founder_id: user.id}))
      conn = guardian_login(conn, user)
      conn = post conn,
                  project_path(conn, :create),
                  project: %{
                    benefits: "some benefits",
                    current_fund: 120.5,
                    fund_asked: 120.5,
                    fund_limit_date: ~D[2010-04-17],
                    karma: 42,
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

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == project_path(conn, :show, id)

      conn = get conn, project_path(conn, :show, id)
      assert html_response(conn, 200) =~ "some vision"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      {:ok, user} = Users.create_user(%{date_of_birth: ~D[2010-04-17], email: "some email",name: "some name", password: "some password", picture_path: "some picture_path", privileges_level: "user", username: "some username"})
      conn = guardian_login(conn, user)
      conn = post conn, project_path(conn, :create), project: @invalid_attrs
      assert html_response(conn, 200) =~ "CREATE PROJECT"
    end
  end

  describe "edit project" do
    setup [:create_project]

    test "does not render form for editing chosen project when wrong user", %{conn: conn, project: project} do
      {:ok, user} = Users.create_user(%{date_of_birth: ~D[2010-04-17], email: "some email1",name: "some name", password: "some password", picture_path: "some picture_path", privileges_level: "user", username: "some username"})
      conn = guardian_login(conn, user)
      conn = get conn, project_path(conn, :edit, project)
      assert html_response(conn, 302)
    end

    test "renders form for editing chosen project", %{conn: conn} do
      {:ok, user} = Users.create_user(%{date_of_birth: ~D[2010-04-17], email: "some email1",name: "some name", password: "some password", picture_path: "some picture_path", privileges_level: "user", username: "some username"})
      {:ok, category} = Categories.create_category(%{name: "some category1"})
      {:ok, community} = Communities.create_community(%{description: "some description", is_group: true, name: "some name1", picture_path: "some picture_path", founder_id: user.id})
      {:ok, project} = Projects.create_project(
        %{
          benefits: "some benefits",
          current_fund: 120.5,
          fund_asked: 120.5,
          fund_limit_date: ~D[2010-04-17],
          karma: 42,
          planning: "some planning",
          state: "funding",
          vision: "some vision123",
          vision_name: "some  vision_name",
          website: "some website",
          category_id: category.id,
          founder_id: user.id,
          community_id: community.id,
          location: "Porto",
          impact: "global"
        }
      )

      conn = guardian_login(conn, user)
      conn = get conn, project_path(conn, :edit, project)
      assert html_response(conn, 200) =~ "EDIT PROJECT"
    end
  end

  describe "update project" do
    setup [:create_project]

    test "redirects when data is valid", %{conn: conn} do
      {:ok, user} = Users.create_user(%{date_of_birth: ~D[2010-04-17], email: "some email1",name: "some name", password: "some password", picture_path: "some picture_path", privileges_level: "user", username: "some username"})
      {:ok, category} = Categories.create_category(%{name: "some category1"})
      {:ok, community} = Communities.create_community(%{description: "some description", is_group: true, name: "some name1", picture_path: "some picture_path", founder_id: user.id})
      {:ok, project} = Projects.create_project(
        %{
          benefits: "some benefits",
          current_fund: 120.5,
          fund_asked: 120.5,
          fund_limit_date: ~D[2010-04-17],
          karma: 42,
          planning: "some planning",
          state: "funding",
          vision: "some vision123",
          vision_name: "some  vision_name",
          website: "some website",
          category_id: category.id,
          founder_id: user.id,
          community_id: community.id,
          location: "Porto",
          impact: "global"
        }
      )
      conn = guardian_login(conn, user)

      conn = put conn, project_path(conn, :update, project.id),  project: %{benefits: "some benefits updated"}

      assert redirected_to(conn) == project_path(conn, :show, project)

      conn = get conn, project_path(conn, :show, project)
      assert html_response(conn, 200) =~ "some benefits updated"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      {:ok, user} = Users.create_user(%{date_of_birth: ~D[2010-04-17], email: "some email1",name: "some name", password: "some password", picture_path: "some picture_path", privileges_level: "user", username: "some username"})
      {:ok, category} = Categories.create_category(%{name: "some category1"})
      {:ok, community} = Communities.create_community(%{description: "some description", is_group: true, name: "some name1", picture_path: "some picture_path", founder_id: user.id})
      {:ok, project} = Projects.create_project(
        %{
          benefits: "some benefits",
          current_fund: 120.5,
          fund_asked: 120.5,
          fund_limit_date: ~D[2010-04-17],
          karma: 42,
          planning: "some planning",
          state: "funding",
          vision: "some vision123",
          vision_name: "some vision_name1",
          website: "some website",
          category_id: category.id,
          founder_id: user.id,
          community_id: community.id,
          location: "Porto",
          impact: "global"
        }
      )

      conn = guardian_login(conn, user)

      conn = put conn, project_path(conn, :update, project.id), project: %{state: "error", impact: "none"}
      #conn = put conn, project_path(conn, :update, project.id), project: %{fund_asked: -50}

      assert html_response(conn, 200) =~ "EDIT PROJECT"
    end
  end

  describe "delete project" do
    setup [:create_project]

    test "deletes chosen project", %{conn: conn} do
      {:ok, user} = Users.create_user(%{date_of_birth: ~D[2010-04-17], email: "some email1",name: "some name", password: "some password", picture_path: "some picture_path", privileges_level: "user", username: "some username"})
      {:ok, category} = Categories.create_category(%{name: "some category1"})
      {:ok, community} = Communities.create_community(%{description: "some description", is_group: true, name: "some name1", picture_path: "some picture_path", founder_id: user.id})
      {:ok, project} = Projects.create_project(
        %{
          benefits: "some benefits",
          current_fund: 120.5,
          fund_asked: 120.5,
          fund_limit_date: ~D[2010-04-17],
          karma: 42,
          planning: "some planning",
          state: "funding",
          vision: "some vision123",
          vision_name: "some vision_name1",
          website: "some website",
          category_id: category.id,
          founder_id: user.id,
          community_id: community.id,
          location: "Porto",
          impact: "global"
        }
      )

      conn = guardian_login(conn, user)
      conn = delete conn, project_path(conn, :delete, project)
      assert redirected_to(conn) =~ "/"
      
      assert_error_sent 404, fn ->
        get conn, project_path(conn, :show, project)
      end
    end
  end

  defp create_project(_) do
    project = fixture(:project)
    {:ok, project: project}
  end
end
