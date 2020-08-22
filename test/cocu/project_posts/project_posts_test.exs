defmodule Cocu.ProjectPostsTest do
  use Cocu.DataCase

  alias Cocu.ProjectPosts

  describe "project_post" do
    alias Cocu.ProjectPosts.ProjectPost
    alias Cocu.Users
    alias Cocu.Users.User
    alias Cocu.Projects
    alias Cocu.Projects.Project
    alias Cocu.Posts
    alias Cocu.Posts.Post
    alias Cocu.Categories
    alias Cocu.Categories.Category
    alias Cocu.Communities

    @valid_attrs %{}
    @update_attrs %{}
    @invalid_attrs %{user_id: nil, project_id: nil, post_id: nil}
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
      impact: "global"
    }
    @category_attrs %{name: "some category"}
    @user_attrs %{
      date_of_birth: ~D[2010-04-17],
      email: "some email",
      name: "some name",
      password: "some password",
      picture_path: "some picture_path",
      privileges_level: "user",
      username: "some username"
    }
    @post_attrs %{content: "some content", title: "some title"}

    setup do
      assert {:ok, %Category{} = category} = Categories.create_category(@category_attrs)
      assert {:ok, %User{} = user} = Users.create_user(@user_attrs)
      {:ok, community} = Communities.create_community(%{founder_id: user.id, name: "test", description: "test"})
      assert {:ok, %Project{} = project} = Projects.create_project(
               Map.merge(@project_attrs, %{category_id: category.id, founder_id: user.id, community_id: community.id})
             )
      assert {:ok, %Post{} = post} = Posts.create_post(@post_attrs)

      {:ok, %{user: user, project: project, post: post}}
    end

    def project_post_fixture(attrs \\ %{}) do
      {:ok, project_post} =
        attrs
        |> Enum.into(@valid_attrs)
        |> ProjectPosts.create_project_post()

      project_post
    end

    test "list_project_post/0 returns all project_post", %{user: user, project: project, post: post} do
      posts = ProjectPosts.list_project_post()
      project_post = project_post_fixture(%{user_id: user.id, project_id: project.id, post_id: post.id})
      posts = posts ++ [project_post]
      assert (ProjectPosts.list_project_post() -- posts) == []
    end

    test "get_project_post!/1 returns the project_post with given id", %{user: user, project: project, post: post} do
      project_post = project_post_fixture(%{user_id: user.id, project_id: project.id, post_id: post.id})
      assert ProjectPosts.get_project_post!(project_post.id) == project_post
    end

    test "create_project_post/1 with valid data creates a project_post", %{user: user, project: project, post: post} do
      assert {:ok, %ProjectPost{} = project_post} = ProjectPosts.create_project_post(
               %{user_id: user.id, project_id: project.id, post_id: post.id}
             )
      assert project_post.post_id == post.id
      assert project_post.project_id == project.id       
    end

    test "create_project_post/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = ProjectPosts.create_project_post(@invalid_attrs)
    end

    test "update_project_post/2 with valid data updates the project_post",
         %{user: user, project: project, post: post} do
      project_post = project_post_fixture(%{user_id: user.id, project_id: project.id, post_id: post.id})
      assert {:ok, project_post} = ProjectPosts.update_project_post(project_post, @update_attrs)
      assert %ProjectPost{} = project_post
    end

    test "update_project_post/2 with invalid data returns error changeset",
         %{user: user, project: project, post: post} do
      project_post = project_post_fixture(%{user_id: user.id, project_id: project.id, post_id: post.id})
      assert {:error, %Ecto.Changeset{}} = ProjectPosts.update_project_post(project_post, @invalid_attrs)
      assert project_post == ProjectPosts.get_project_post!(project_post.id)
    end

    test "delete_project_post/1 deletes the project_post", %{user: user, project: project, post: post} do
      project_post = project_post_fixture(%{user_id: user.id, project_id: project.id, post_id: post.id})
      assert {:ok, %ProjectPost{}} = ProjectPosts.delete_project_post(project_post)
      assert_raise Ecto.NoResultsError, fn -> ProjectPosts.get_project_post!(project_post.id) end
    end

    test "change_project_post/1 returns a project_post changeset", %{user: user, project: project, post: post} do
      project_post = project_post_fixture(%{user_id: user.id, project_id: project.id, post_id: post.id})
      assert %Ecto.Changeset{} = ProjectPosts.change_project_post(project_post)
    end
  end
end
