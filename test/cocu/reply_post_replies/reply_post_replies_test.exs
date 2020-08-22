defmodule Cocu.ReplyPostRepliesTest do
  use Cocu.DataCase

  alias Cocu.ReplyPostReplies

  describe "reply_post_reply_test" do
    alias Cocu.ReplyPostReplies.ReplyPostReply
    alias Cocu.Posts
    alias Cocu.Posts.Post

    @valid_attrs %{}
    @update_attrs %{}
    @invalid_attrs %{parent_post_reply_id: nil, child_post_reply_id: nil}
    #@user_attrs %{date_of_birth: ~D[2010-04-17], email: "some email", name: "some name", password: "some password", picture_path: "some picture_path", privileges_level: "user", username: "some username"}
    @post_attrs %{content: "some content", title: "some title"}
    #@reply_attrs %{content: "some content"}
    #@user2_attrs %{date_of_birth: ~D[2010-04-17], email: "some email2", name: "some name2", password: "some password", picture_path: "some picture_path", privileges_level: "user", username: "some username2"}
    @post2_attrs %{content: "some content", title: "some title2"}

    setup do
      assert {:ok, %Post{} = post} = Posts.create_post(@post_attrs)
      assert {:ok, %Post{} = post2} = Posts.create_post(@post2_attrs)
      {:ok, %{post: post, post2: post2}}
    end

    def reply_post_reply_fixture(attrs \\ %{}) do
      {:ok, reply_post_reply} =
        attrs
        |> Enum.into(@valid_attrs)
        |> ReplyPostReplies.create_reply_post_reply()

      reply_post_reply
    end

    test "list_reply_post_reply/0 returns all reply_post_reply", %{post: post, post2: post2} do
      replies = ReplyPostReplies.list_reply_post_reply()
      reply_post_reply = reply_post_reply_fixture(%{parent_post_reply_id: post.id, child_post_reply_id: post2.id})
      replies = replies ++ [reply_post_reply]
      assert ReplyPostReplies.list_reply_post_reply() == replies
    end


    test "get_reply_post_reply!/1 returns the reply_post_reply with given id", %{post: post, post2: post2} do
      reply_post_reply = reply_post_reply_fixture(%{parent_post_reply_id: post.id, child_post_reply_id: post2.id})
      assert ReplyPostReplies.get_reply_post_reply!(reply_post_reply.id) == reply_post_reply
    end

    test "create_reply_post_reply/1 with valid data creates a reply_post_reply", %{post: post, post2: post2} do
      assert {:ok, %ReplyPostReply{} = reply_post_reply } = ReplyPostReplies.create_reply_post_reply(%{parent_post_reply_id: post.id, child_post_reply_id: post2.id})
      assert reply_post_reply.parent_post_reply_id == post.id
      assert reply_post_reply.child_post_reply_id == post2.id
    end

    test "create_reply_post_reply/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = ReplyPostReplies.create_reply_post_reply(@invalid_attrs)
    end

    test "update_reply_post_reply/2 with valid data updates the reply_post_reply", %{post: post, post2: post2} do
      reply_post_reply = reply_post_reply_fixture(%{parent_post_reply_id: post.id, child_post_reply_id: post2.id})
      assert {:ok, reply_post_reply} = ReplyPostReplies.update_reply_post_reply(reply_post_reply, @update_attrs)
      assert %ReplyPostReply{} = reply_post_reply
    end

    test "update_reply_post_reply/2 with invalid data returns error changeset", %{post: post, post2: post2} do
      reply_post_reply = reply_post_reply_fixture(%{parent_post_reply_id: post.id, child_post_reply_id: post2.id})
      assert {:error, %Ecto.Changeset{}} = ReplyPostReplies.update_reply_post_reply(reply_post_reply, @invalid_attrs)
      assert reply_post_reply == ReplyPostReplies.get_reply_post_reply!(reply_post_reply.id)
    end

    test "delete_reply_post_reply/1 deletes the reply_post_reply", %{post: post, post2: post2} do
      reply_post_reply = reply_post_reply_fixture(%{parent_post_reply_id: post.id, child_post_reply_id: post2.id})
      assert {:ok, %ReplyPostReply{}} = ReplyPostReplies.delete_reply_post_reply(reply_post_reply)
      assert_raise Ecto.NoResultsError, fn -> ReplyPostReplies.get_reply_post_reply!(reply_post_reply.id) end
    end

    test "change_reply_post_reply/1 returns a reply_post_reply changeset", %{post: post, post2: post2} do
      reply_post_reply = reply_post_reply_fixture(%{parent_post_reply_id: post.id, child_post_reply_id: post2.id})
      assert %Ecto.Changeset{} = ReplyPostReplies.change_reply_post_reply(reply_post_reply)
    end

  end
end
