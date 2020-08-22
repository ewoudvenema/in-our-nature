defmodule Cocu.NotificationCommentsTest do
  use Cocu.DataCase

  alias Cocu.NotificationComments
  alias Cocu.Notifications
  alias Cocu.Notifications.Notification
  alias Cocu.Users
  alias Cocu.Users.User
  alias Cocu.Posts
  alias Cocu.Posts.Post
  alias Cocu.Projects
  alias Cocu.Projects.Project
  alias Cocu.ProjectComments
  alias Cocu.ProjectComments.ProjectComment
  alias Cocu.Categories
  alias Cocu.Categories.Category
  alias Cocu.Communities

  describe "notification_comment" do
    alias Cocu.NotificationComments.NotificationComment

    @valid_attrs %{}
    @update_attrs %{}
    @invalid_attrs %{notification_id: nil, project_comment_id: nil}
    @notification_attrs %{seen: false}
    @user_attrs %{date_of_birth: ~D[2010-04-17], email: "some email", name: "some name", password: "some password", picture_path: "some picture_path", privileges_level: "user", username: "some username"}
    @post_attrs %{content: "some content", title: "some title"}
    @project_attrs %{benefits: "some benefits", current_fund: 120.5, fund_asked: 120.5, fund_limit_date: ~D[2010-04-17], karma: 42, planning: "some planning", state: "funding", vision: "some vision", vision_name: "some vision_name", website: "some website", location: "Porto",
    impact: "global"}
    @category_attrs %{name: "some category"}

    setup do
      assert {:ok, %Category{} = category} = Categories.create_category(@category_attrs)
      assert {:ok, %Notification{} = notification} = Notifications.create_notification(@notification_attrs)
      assert {:ok, %Post{} = post} = Posts.create_post(@post_attrs)
      assert {:ok, %User{} = user} = Users.create_user(@user_attrs)
      {:ok, community} = Communities.create_community(%{founder_id: user.id, name: "test", description: "test"})
      {:ok, %Project{} = project} = Projects.create_project(
        Map.merge(@project_attrs, %{founder_id: user.id, category_id: category.id, community_id: community.id})
      )
      assert {:ok, %ProjectComment{} = project_comment} = ProjectComments.create_project_comment(%{user_id: user.id, project_id: project.id, post_id: post.id})
      {:ok, %{notification: notification, project_comment: project_comment}}
    end

    def notification_comment_fixture(attrs \\ %{}) do
      {:ok, notification_comment} =
        attrs
        |> Enum.into(@valid_attrs)
        |> NotificationComments.create_notification_comment()

      notification_comment
    end

    test "list_notification_comment/0 returns all notification_comment", %{notification: notification, project_comment: project_comment} do
      notifications = NotificationComments.list_notification_comment()
      notification_comment = notification_comment_fixture(%{notification_id: notification.id, project_comment_id: project_comment.id})
      notifications = notifications ++ [notification_comment]
      assert NotificationComments.list_notification_comment() == notifications
    end

    test "get_notification_comment!/1 returns the notification_comment with given id", %{notification: notification, project_comment: project_comment} do
      notification_comment = notification_comment_fixture(%{notification_id: notification.id, project_comment_id: project_comment.id})
      assert NotificationComments.get_notification_comment!(notification_comment.id) == notification_comment
    end

    test "create_notification_comment/1 with valid data creates a notification_comment", %{notification: notification, project_comment: project_comment} do
      assert {:ok, %NotificationComment{} = notification_comment } = NotificationComments.create_notification_comment(%{notification_id: notification.id, project_comment_id: project_comment.id})
      assert notification_comment.project_comment_id == project_comment.id
    end

    test "create_notification_comment/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = NotificationComments.create_notification_comment(@invalid_attrs)
    end

    test "update_notification_comment/2 with valid data updates the notification_comment", %{notification: notification, project_comment: project_comment} do
      notification_comment = notification_comment_fixture(%{notification_id: notification.id, project_comment_id: project_comment.id})
      assert {:ok, notification_comment} = NotificationComments.update_notification_comment(notification_comment, @update_attrs)
      assert %NotificationComment{} = notification_comment
    end

    test "update_notification_comment/2 with invalid data returns error changeset", %{notification: notification, project_comment: project_comment} do
      notification_comment = notification_comment_fixture(%{notification_id: notification.id, project_comment_id: project_comment.id})
      assert {:error, %Ecto.Changeset{}} = NotificationComments.update_notification_comment(notification_comment, @invalid_attrs)
      assert notification_comment == NotificationComments.get_notification_comment!(notification_comment.id)
    end

    test "delete_notification_comment/1 deletes the notification_comment", %{notification: notification, project_comment: project_comment} do
      notification_comment = notification_comment_fixture(%{notification_id: notification.id, project_comment_id: project_comment.id})
      assert {:ok, %NotificationComment{}} = NotificationComments.delete_notification_comment(notification_comment)
      assert_raise Ecto.NoResultsError, fn -> NotificationComments.get_notification_comment!(notification_comment.id) end
    end

    test "change_notification_comment/1 returns a notification_comment changeset", %{notification: notification, project_comment: project_comment} do
      notification_comment = notification_comment_fixture(%{notification_id: notification.id, project_comment_id: project_comment.id})
      assert %Ecto.Changeset{} = NotificationComments.change_notification_comment(notification_comment)
    end
  end
end
