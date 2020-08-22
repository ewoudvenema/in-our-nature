defmodule Cocu.CommunityProjectsTest do
  use Cocu.DataCase

  alias Cocu.CommunityProjects
  alias Cocu.Projects
  alias Cocu.Projects.Project
  alias Cocu.Users
  alias Cocu.Users.User
  alias Cocu.Categories
  alias Cocu.Categories.Category
  alias Cocu.Communities

  describe "community_project" do
    alias Cocu.CommunityProjects.CommunityProject

    @valid_attrs %{}
    #@update_attrs %{}
    @category_attrs %{name: "some name"}
    @invalid_attrs %{project_id: nil, community_id: nil}
    @project_attrs %{
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
      impact: "international"
    }
    @project2_attrs %{
      benefits: "some benefits",
      current_fund: 120.5,
      fund_asked: 120.5,
      fund_limit_date: ~D[2010-04-17],
      karma: 42,
      planning: "some planning",
      state: "funding",
      vision: "some vision",
      vision_name: "some vision_name2",
      website: "some website",
      location: "Porto",
      impact: "international"
    }
    @user_attrs %{date_of_birth: ~D[2010-04-17], email: "some email", name: "some name", password: "some password", picture_path: "some picture_path", privileges_level: "user", username: "some username"}
    

    setup do
      assert {:ok, %User{} = user} = Users.create_user(@user_attrs)
      assert {:ok, %Category{} = category} = Categories.create_category(@category_attrs)
      {:ok, community} = Communities.create_community(%{founder_id: user.id, name: "test", description: "test"})                
      assert {:ok, %Project{} = project} = Projects.create_project(Map.merge(@project_attrs, %{founder_id: user.id, category_id: category.id, community_id: community.id}))
      assert {:ok, %Project{} = project2} = Projects.create_project(Map.merge(@project2_attrs, %{founder_id: user.id, category_id: category.id, community_id: community.id}))
      
      {:ok, %{project: project, community: community, project2: project2}}
    end

    def community_project_fixture(attrs \\ %{}) do
      {:ok, community_project} =
        attrs
        |> Enum.into(@valid_attrs)
        |> CommunityProjects.create_community_project()

      community_project
    end

    test "list_community_project/0 returns all community_project", %{project: project, community: community} do
      projects = CommunityProjects.list_community_project()
      community_project = community_project_fixture(%{project_id: project.id, community_id: community.id})
      projects = projects ++ [community_project]
      assert CommunityProjects.list_community_project() == projects
    end

    test "get_community_project!/1 returns the community_project with given id",
         %{project: project, community: community} do
      community_project = community_project_fixture(%{project_id: project.id, community_id: community.id})
      assert CommunityProjects.get_community_project!(community_project.id) == community_project
    end

    test "create_community_project/1 with valid data creates a community_project",
         %{project: project, community: community} do
      assert {:ok, %CommunityProject{}} = CommunityProjects.create_community_project(
               %{project_id: project.id, community_id: community.id}
             )
    end

    test "create_community_project/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = CommunityProjects.create_community_project(@invalid_attrs)
    end

    test "update_community_project/2 with valid data updates the community_project",
         %{project: project, community: community, project2: project2} do
      community_project = community_project_fixture(%{project_id: project.id, community_id: community.id})
      assert {:ok, community_project} = CommunityProjects.update_community_project(
               community_project,
               %{project_id: project2.id, community_id: community.id}
             )
      assert %CommunityProject{} = community_project
    end

    test "update_community_project/2 with invalid data returns error changeset",
         %{project: project, community: community} do
      community_project = community_project_fixture(%{project_id: project.id, community_id: community.id})
      assert {:error, %Ecto.Changeset{}} = CommunityProjects.update_community_project(community_project, @invalid_attrs)
    end

    test "delete_community_project/1 deletes the community_project", %{project: project, community: community} do
      community_project = community_project_fixture(%{project_id: project.id, community_id: community.id})
      assert {:ok, %CommunityProject{}} = CommunityProjects.delete_community_project(community_project)
      assert_raise Ecto.NoResultsError, fn -> CommunityProjects.get_community_project!(community_project.id) end
    end

    test "change_community_project/1 returns a community_project changeset",
         %{project: project, community: community} do
      community_project = community_project_fixture(%{project_id: project.id, community_id: community.id})
      assert %Ecto.Changeset{} = CommunityProjects.change_community_project(community_project)
    end
  end
end
