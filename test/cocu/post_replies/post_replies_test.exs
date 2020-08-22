defmodule Cocu.PostRepliesTest do
  use Cocu.DataCase

  alias Cocu.PostReplies
  alias Cocu.Users
  alias Cocu.Users.User
  alias Cocu.Posts
  alias Cocu.Posts.Post

  describe "post_reply" do
    alias Cocu.PostReplies.PostReply

    @valid_attrs %{content: "some content"}
    @update_attrs %{content: "some updated content"}
    @invalid_attrs %{content: nil}
    @user_attrs %{date_of_birth: ~D[2010-04-17], email: "some email", name: "some name", password: "some password", picture_path: "some picture_path", privileges_level: "user", username: "some username"}
    @post_attrs %{content: "some content", title: "some title"}    

    setup do
      assert {:ok, %Post{} = post} = Posts.create_post(@post_attrs)  
      assert {:ok, %User{} = user} = Users.create_user(@user_attrs)
      {:ok, %{user: user, post: post}}            
    end

    def post_reply_fixture(attrs \\ %{}) do
      {:ok, post_reply} =
        attrs
        |> Enum.into(@valid_attrs)
        |> PostReplies.create_post_reply()

      post_reply
    end

    test "list_post_reply/0 returns all post_reply", %{user: user, post: post} do
      replies = PostReplies.list_post_reply()
      post_reply = post_reply_fixture(%{content: @valid_attrs.content, user_id: user.id, post_id: post.id})
      replies = replies ++ [post_reply]
      assert PostReplies.list_post_reply() == replies
    end

    test "get_post_reply!/1 returns the post_reply with given id", %{user: user, post: post} do
      post_reply = post_reply_fixture(%{content: @valid_attrs.content, user_id: user.id, post_id: post.id})
      assert PostReplies.get_post_reply!(post_reply.id) == post_reply
    end

    test "create_post_reply/1 with valid data creates a post_reply", %{user: user, post: post} do
      assert {:ok, %PostReply{} = post_reply} = PostReplies.create_post_reply(%{content: @valid_attrs.content, user_id: user.id, post_id: post.id})
      assert post_reply.content == "some content"
    end

    test "create_post_reply/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = PostReplies.create_post_reply(@invalid_attrs)
    end

    test "update_post_reply/2 with valid data updates the post_reply", %{user: user, post: post} do
      post_reply = post_reply_fixture(%{content: @valid_attrs.content, user_id: user.id, post_id: post.id})
      assert {:ok, post_reply} = PostReplies.update_post_reply(post_reply, %{content: @update_attrs.content, user_id: user.id, post_id: post.id})
      assert %PostReply{} = post_reply
      assert post_reply.content == "some updated content"
    end

    test "update_post_reply/2 with invalid data returns error changeset", %{user: user, post: post} do
      post_reply = post_reply_fixture(%{content: @valid_attrs.content, user_id: user.id, post_id: post.id})
      assert {:error, %Ecto.Changeset{}} = PostReplies.update_post_reply(post_reply, @invalid_attrs)
      assert post_reply == PostReplies.get_post_reply!(post_reply.id)
    end

    test "delete_post_reply/1 deletes the post_reply", %{user: user, post: post} do
      post_reply = post_reply_fixture(%{content: @valid_attrs.content, user_id: user.id, post_id: post.id})
      assert {:ok, %PostReply{}} = PostReplies.delete_post_reply(post_reply)
      assert_raise Ecto.NoResultsError, fn -> PostReplies.get_post_reply!(post_reply.id) end
    end

    test "change_post_reply/1 returns a post_reply changeset", %{user: user, post: post} do
      post_reply = post_reply_fixture(%{content: @valid_attrs.content, user_id: user.id, post_id: post.id})
      assert %Ecto.Changeset{} = PostReplies.change_post_reply(post_reply)
    end
  end
end
