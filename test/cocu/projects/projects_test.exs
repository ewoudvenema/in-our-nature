defmodule Cocu.ProjectsTest do
  use Cocu.DataCase

  alias Cocu.Projects
  alias Cocu.Categories
  alias Cocu.Communities
  alias Cocu.Users

  describe "project" do
    alias Cocu.Projects.Project

    @user_attrs %{
      date_of_birth: ~D[2010-04-17],
      email: "some email",
      name: "some name",
      password: "some password",
      picture_path: "some picture_path",
      privileges_level: "user",
      username: "some username",

    }
    @valid_attrs %{
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
      location: "Porto",
      impact: "global"
    }
    @update_attrs %{
      benefits: "some updated benefits",
      current_fund: 456.7,
      fund_asked: 456.7,
      fund_limit_date: ~D[2011-05-18],
      karma: 43,
      planning: "some updated planning",
      state: "creation",
      vision: "some updated vision",
      vision_name: "some updated vision_name",
      website: "some updated website",
      location: "Lisboa",
      impact: "regional"
    }
    @invalid_attrs %{
      benefits: nil,
      current_fund: nil,
      fund_asked: nil,
      fund_limit_date: nil,
      karma: nil,
      planning: nil,
      state: nil,
      vision: nil,
      vision_name: nil,
      website: nil,
      location: nil,
      impact: nil
    }
    @category_attrs %{name: "some category"}

    defp project_fixture(_attrs \\ %{}) do
      {:ok, category} = Categories.create_category(@category_attrs)
      {:ok, user} = Users.create_user(@user_attrs)
      {:ok, community} = Communities.create_community(%{founder_id: user.id, name: "test", description: "test"})
      {:ok, project} = Projects.create_project(
        Map.merge(@valid_attrs, %{founder_id: user.id, category_id: category.id, community_id: community.id})
      )

      project
    end

    test "list_project/0 returns all project" do
      project_list = Projects.list_project()
      project = project_fixture()
      project_list = project_list ++ [project]
      assert (Projects.list_project() -- project_list) == []
    end

    test "get_project!/1 returns the project with given id" do
      project = project_fixture()
      assert Projects.get_project!(project.id) == project
    end

    test "create_project/1 with valid data creates a project" do
      project = project_fixture()
      assert project.benefits == "some benefits"
      assert project.current_fund == 120.5
      assert project.fund_asked == 120.5
      assert project.fund_limit_date == ~D[2010-04-17]
      assert project.karma == 42
      assert project.planning == "some planning"
      assert project.state == "funding"
      assert project.vision == "some vision"
      assert project.vision_name == "some vision_name"
      assert project.website == "some website"
      assert project.location == "Porto"
      assert project.impact == "global"
    end

    test "create_project/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Projects.create_project(@invalid_attrs)
    end

    test "update_project/2 with valid data updates the project" do
      project = project_fixture()
      assert {:ok, project} = Projects.update_project(project, @update_attrs)
      assert %Project{} = project
      assert project.benefits == "some updated benefits"
      assert project.current_fund == 456.7
      assert project.fund_asked == 456.7
      assert project.fund_limit_date == ~D[2011-05-18]
      assert project.karma == 43
      assert project.planning == "some updated planning"
      assert project.state == "creation"
      assert project.vision == "some updated vision"
      assert project.vision_name == "some updated vision_name"
      assert project.website == "some updated website"
      assert project.location == "Lisboa"
      assert project.impact == "regional"
    end

    test "update_project/2 with invalid data returns error changeset" do
      project = project_fixture()
      assert {:error, %Ecto.Changeset{}} = Projects.update_project(project, @invalid_attrs)
      assert project == Projects.get_project!(project.id)
    end

    test "delete_project/1 deletes the project" do
      project = project_fixture()
      assert {:ok, %Project{}} = Projects.delete_project(project)
      assert_raise Ecto.NoResultsError, fn -> Projects.get_project!(project.id) end
    end

    test "change_project/1 returns a project changeset" do
      project = project_fixture()
      assert %Ecto.Changeset{} = Projects.change_project(project)
    end
  end
end
