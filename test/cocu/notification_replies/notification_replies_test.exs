defmodule Cocu.NotificationRepliesTest do
  use Cocu.DataCase

  alias Cocu.NotificationReplies
  alias Cocu.Notifications
  alias Cocu.Notifications.Notification
  alias Cocu.Users
  alias Cocu.Users.User
  alias Cocu.Posts
  alias Cocu.Posts.Post
  alias Cocu.PostReplies
  alias Cocu.PostReplies.PostReply

  describe "notification_reply" do
    alias Cocu.NotificationReplies.NotificationReply

    @valid_attrs %{}
    @update_attrs %{}
    @invalid_attrs %{notification_id: nil, post_reply_id: nil}
    @notification_attrs %{seen: false}
    @user_attrs %{date_of_birth: ~D[2010-04-17], email: "some email", name: "some name", password: "some password", picture_path: "some picture_path", privileges_level: "user", username: "some username"}
    @post_attrs %{content: "some content", title: "some title"}
    @post_reply_attrs %{content: "some content"}


    setup do
      assert {:ok, %Notification{} = notification} = Notifications.create_notification(@notification_attrs)
      assert {:ok, %Post{} = post} = Posts.create_post(@post_attrs)
      assert {:ok, %User{} = user} = Users.create_user(@user_attrs)
      assert {:ok, %PostReply{} = post_reply} = PostReplies.create_post_reply(%{content: @post_reply_attrs.content, user_id: user.id, post_id: post.id})
      {:ok, %{notification: notification, post_reply: post_reply}}
    end

    def notification_reply_fixture(attrs \\ %{}) do
      {:ok, notification_reply} =
        attrs
        |> Enum.into(@valid_attrs)
        |> NotificationReplies.create_notification_reply()

      notification_reply
    end

    test "list_notification_reply/0 returns all notification_reply", %{notification: notification, post_reply: post_reply} do
      notifications = NotificationReplies.list_notification_reply()
      notification_reply = notification_reply_fixture(%{notification_id: notification.id, post_reply_id: post_reply.id})
      notifications = notifications ++ [notification_reply]
      assert NotificationReplies.list_notification_reply() == notifications
    end

    test "get_notification_reply!/1 returns the notification_reply with given id", %{notification: notification, post_reply: post_reply} do
      notification_reply = notification_reply_fixture(%{notification_id: notification.id, post_reply_id: post_reply.id})
      assert NotificationReplies.get_notification_reply!(notification_reply.id) == notification_reply
    end

    test "create_notification_reply/1 with valid data creates a notification_reply", %{notification: notification, post_reply: post_reply} do
      assert {:ok, %NotificationReply{} = notification_reply} = NotificationReplies.create_notification_reply(%{notification_id: notification.id, post_reply_id: post_reply.id})
      assert notification_reply.post_reply_id == post_reply.id
    end

    test "create_notification_reply/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = NotificationReplies.create_notification_reply(@invalid_attrs)
    end

    test "update_notification_reply/2 with valid data updates the notification_reply", %{notification: notification, post_reply: post_reply} do
      notification_reply = notification_reply_fixture(%{notification_id: notification.id, post_reply_id: post_reply.id})
      assert {:ok, notification_reply} = NotificationReplies.update_notification_reply(notification_reply, @update_attrs)
      assert %NotificationReply{} = notification_reply
    end

    test "update_notification_reply/2 with invalid data returns error changeset", %{notification: notification, post_reply: post_reply} do
      notification_reply = notification_reply_fixture(%{notification_id: notification.id, post_reply_id: post_reply.id})
      assert {:error, %Ecto.Changeset{}} = NotificationReplies.update_notification_reply(notification_reply, @invalid_attrs)
      assert notification_reply == NotificationReplies.get_notification_reply!(notification_reply.id)
    end

    test "delete_notification_reply/1 deletes the notification_reply", %{notification: notification, post_reply: post_reply} do
      notification_reply = notification_reply_fixture(%{notification_id: notification.id, post_reply_id: post_reply.id})
      assert {:ok, %NotificationReply{}} = NotificationReplies.delete_notification_reply(notification_reply)
      assert_raise Ecto.NoResultsError, fn -> NotificationReplies.get_notification_reply!(notification_reply.id) end
    end

    test "change_notification_reply/1 returns a notification_reply changeset", %{notification: notification, post_reply: post_reply} do
      notification_reply = notification_reply_fixture(%{notification_id: notification.id, post_reply_id: post_reply.id})
      assert %Ecto.Changeset{} = NotificationReplies.change_notification_reply(notification_reply)
    end
  end
end
