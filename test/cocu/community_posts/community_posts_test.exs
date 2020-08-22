defmodule Cocu.CommunityPostsTest do
  use Cocu.DataCase

  alias Cocu.CommunityPosts
  alias Cocu.Users
  alias Cocu.Users.User
  alias Cocu.Communities
  alias Cocu.Communities.Community
  alias Cocu.Posts
  alias Cocu.Posts.Post

  describe "community_post" do
    alias Cocu.CommunityPosts.CommunityPost

    @valid_attrs %{}
    @update_attrs %{}
    @invalid_attrs %{user_id: nil, community_id: nil, post_id: nil}
    @user_attrs %{date_of_birth: ~D[2010-04-17], email: "some email", name: "some name", password: "some password", picture_path: "some picture_path", privileges_level: "user", username: "some username"}
    @community_attrs %{description: "some description", is_group: true, name: "some name", picture_path: "some picture_path"}
    @post_attrs %{content: "some content", title: "some title"}
    @post_attrs2 %{content: "some content2", title: "some title2"}
    
    def community_post_fixture(attrs \\ %{}) do
      {:ok, community_post} =
        attrs
        |> Enum.into(@valid_attrs)
        |> CommunityPosts.create_community_post()

      community_post
    end

    setup do
      assert {:ok, %User{} = user} = Users.create_user(@user_attrs)
      assert {:ok, %Community{} = community} = Communities.create_community(Map.merge(@community_attrs, %{founder_id: user.id}))
      assert {:ok, %Post{} = post} = Posts.create_post(@post_attrs)
      assert {:ok, %Post{} = post2} = Posts.create_post(@post_attrs2)

      valid_attrs = Map.put(@valid_attrs, :user_id, user.id)
      valid_attrs = Map.put(valid_attrs, :community_id, community.id)
      valid_attrs = Map.put(valid_attrs, :post_id, post.id)

      update_attrs = Map.put(@update_attrs, :user_id, user.id)
      update_attrs = Map.put(update_attrs, :community_id, community.id)
      update_attrs = Map.put(update_attrs, :post_id, post2.id)
      
      {:ok, %{valid_attrs: valid_attrs, update_attrs: update_attrs}}
    end

    test "list_community_post/0 returns all community_post", %{valid_attrs: valid_attrs} do
      posts = CommunityPosts.list_community_post()
      community_post = community_post_fixture(valid_attrs)
      posts = posts ++ [community_post]
      assert (CommunityPosts.list_community_post() -- posts ) == []
    end

    test "get_community_post!/1 returns the community_post with given id", %{valid_attrs: valid_attrs} do
      community_post = community_post_fixture(valid_attrs)
      assert CommunityPosts.get_community_post!(community_post.id) == community_post
    end

    test "create_community_post/1 with valid data creates a community_post", %{valid_attrs: valid_attrs} do
      assert {:ok, %CommunityPost{}} = CommunityPosts.create_community_post(valid_attrs)
    end

    test "create_community_post/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = CommunityPosts.create_community_post(@invalid_attrs)
    end

    test "update_community_post/2 with valid data updates the community_post", %{valid_attrs: valid_attrs} do
      community_post = community_post_fixture(valid_attrs)
      assert {:ok, community_post} = CommunityPosts.update_community_post(community_post, @update_attrs)
      assert %CommunityPost{} = community_post
    end

    test "update_community_post/2 with invalid data returns error changeset", %{valid_attrs: valid_attrs} do
      community_post = community_post_fixture(valid_attrs)
      assert {:error, %Ecto.Changeset{}} = CommunityPosts.update_community_post(community_post, @invalid_attrs)
      assert community_post == CommunityPosts.get_community_post!(community_post.id)
    end

    test "delete_community_post/1 deletes the community_post", %{valid_attrs: valid_attrs} do
      community_post = community_post_fixture(valid_attrs)
      assert {:ok, %CommunityPost{}} = CommunityPosts.delete_community_post(community_post)
      assert_raise Ecto.NoResultsError, fn -> CommunityPosts.get_community_post!(community_post.id) end
    end

    test "change_community_post/1 returns a community_post changeset", %{valid_attrs: valid_attrs} do
      community_post = community_post_fixture(valid_attrs)
      assert %Ecto.Changeset{} = CommunityPosts.change_community_post(community_post)
    end
  end
end
