defmodule Cocu.ProjectCommentsTest do
  use Cocu.DataCase

  alias Cocu.ProjectComments

  describe "project_comment" do
    alias Cocu.ProjectComments.ProjectComment
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
    @category_attrs %{name: "some category"}

    setup do
      {:ok, %Category{} = category} = Categories.create_category(@category_attrs)
      {:ok, %User{} = user} = Users.create_user(@user_attrs)
      {:ok, community} = Communities.create_community(%{founder_id: user.id, name: "test", description: "test"})
      {:ok, %Project{} = project} = Projects.create_project(
        Map.merge(@project_attrs, %{founder_id: user.id, category_id: category.id, community_id: community.id})
      )
      {:ok, %Post{} = post} = Posts.create_post(@post_attrs)

      {:ok, %{user: user, project: project, post: post}}
    end

    defp project_comment_fixture(%{user_id: user_id, project_id: project_id, post_id: post_id}) do
      {:ok, project_comment} = ProjectComments.create_project_comment(
        Map.merge(@valid_attrs, %{user_id: user_id, project_id: project_id, post_id: post_id})
      )

      project_comment
    end

    test "list_project_comment/0 returns all project_comment", %{user: user, project: project, post: post} do
      comments = ProjectComments.list_project_comment()
      project_comment = project_comment_fixture(%{user_id: user.id, project_id: project.id, post_id: post.id})
      comments = comments ++ [project_comment]
      assert ProjectComments.list_project_comment() == comments
    end

    test "get_project_comment!/1 returns the project_comment with given id",
         %{user: user, project: project, post: post} do
      project_comment = project_comment_fixture(%{user_id: user.id, project_id: project.id, post_id: post.id})
      assert ProjectComments.get_project_comment!(project_comment.id) == project_comment
    end

    test "create_project_comment/1 with valid data creates a project_comment",
         %{user: user, project: project, post: post} do
      assert {:ok, %ProjectComment{} = project_comment} = ProjectComments.create_project_comment(
               %{user_id: user.id, project_id: project.id, post_id: post.id}
             )
      assert project_comment.user_id == user.id
      assert project_comment.project_id == project.id
      assert project_comment.post_id == post.id
    end

    test "create_project_comment/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = ProjectComments.create_project_comment(@invalid_attrs)
    end

    test "update_project_comment/2 with valid data updates the project_comment",
         %{user: user, project: project, post: post} do
      project_comment = project_comment_fixture(%{user_id: user.id, project_id: project.id, post_id: post.id})
      assert {:ok, project_comment} = ProjectComments.update_project_comment(project_comment, @update_attrs)
      assert %ProjectComment{} = project_comment
    end

    test "update_project_comment/2 with invalid data returns error changeset",
         %{user: user, project: project, post: post} do
      project_comment = project_comment_fixture(%{user_id: user.id, project_id: project.id, post_id: post.id})
      assert {:error, %Ecto.Changeset{}} = ProjectComments.update_project_comment(project_comment, @invalid_attrs)
      assert project_comment == ProjectComments.get_project_comment!(project_comment.id)
    end

    test "delete_project_comment/1 deletes the project_comment", %{user: user, project: project, post: post} do
      project_comment = project_comment_fixture(%{user_id: user.id, project_id: project.id, post_id: post.id})
      assert {:ok, %ProjectComment{}} = ProjectComments.delete_project_comment(project_comment)
      assert_raise Ecto.NoResultsError, fn -> ProjectComments.get_project_comment!(project_comment.id) end
    end

    test "change_project_comment/1 returns a project_comment changeset", %{user: user, project: project, post: post} do
      project_comment = project_comment_fixture(%{user_id: user.id, project_id: project.id, post_id: post.id})
      assert %Ecto.Changeset{} = ProjectComments.change_project_comment(project_comment)
    end
  end
end
