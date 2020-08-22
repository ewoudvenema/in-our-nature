defmodule Cocu.UserFollowUsersTest do
  use Cocu.DataCase

  alias Cocu.UserFollowUsers
  alias Cocu.Users
  alias Cocu.Users.User

  describe "user_follow_user" do
    alias Cocu.UserFollowUsers.UserFollowUser

    @valid_attrs %{}
    @update_attrs %{}
    @invalid_attrs %{followed_user_id: nil, follower_user_id: nil}
    @user_attrs %{date_of_birth: ~D[2010-04-17], email: "some email", name: "some name", password: "some password", picture_path: "some picture_path", privileges_level: "user", username: "some username"}
    @user2_attrs %{date_of_birth: ~D[2010-04-17], email: "some email2", name: "some name2", password: "some password", picture_path: "some picture_path", privileges_level: "user", username: "some username2"}

    setup do
      assert {:ok, %User{} = user} = Users.create_user(@user_attrs)
      assert {:ok, %User{} = user2} = Users.create_user(@user2_attrs)

      {:ok, %{user: user, user2: user2}}
    end

    def user_follow_user_fixture(attrs \\ %{}) do
      {:ok, user_follow_user} =
        attrs
        |> Enum.into(@valid_attrs)
        |> UserFollowUsers.create_user_follow_user()

      user_follow_user
    end

    test "list_user_follow_user/0 returns all user_follow_user", %{user: user, user2: user2} do
      follows = UserFollowUsers.list_user_follow_user()
      user_follow_user = user_follow_user_fixture(%{followed_user_id: user.id, follower_user_id: user2.id})
      follows = follows ++ [user_follow_user]
      assert UserFollowUsers.list_user_follow_user() == follows
    end

    test "get_user_follow_user!/1 returns the user_follow_user with given id", %{user: user, user2: user2} do
      user_follow_user = user_follow_user_fixture(%{followed_user_id: user.id, follower_user_id: user2.id})
      assert UserFollowUsers.get_user_follow_user!(user_follow_user.id) == user_follow_user
    end

    test "create_user_follow_user/1 with valid data creates a user_follow_user", %{user: user, user2: user2} do
      assert {:ok, %UserFollowUser{} = user_follow_user } = UserFollowUsers.create_user_follow_user(%{followed_user_id: user.id, follower_user_id: user2.id})
      assert user_follow_user.followed_user_id == user.id
      assert user_follow_user.follower_user_id == user2.id
    end

    test "create_user_follow_user/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = UserFollowUsers.create_user_follow_user(@invalid_attrs)
    end

    test "update_user_follow_user/2 with valid data updates the user_follow_user", %{user: user, user2: user2} do
      user_follow_user = user_follow_user_fixture(%{followed_user_id: user.id, follower_user_id: user2.id})
      assert {:ok, user_follow_user} = UserFollowUsers.update_user_follow_user(user_follow_user, @update_attrs)
      assert %UserFollowUser{} = user_follow_user
    end

    test "update_user_follow_user/2 with invalid data returns error changeset", %{user: user, user2: user2} do
      user_follow_user = user_follow_user_fixture(%{followed_user_id: user.id, follower_user_id: user2.id})
      assert {:error, %Ecto.Changeset{}} = UserFollowUsers.update_user_follow_user(user_follow_user, @invalid_attrs)
      assert user_follow_user == UserFollowUsers.get_user_follow_user!(user_follow_user.id)
    end

    test "delete_user_follow_user/1 deletes the user_follow_user", %{user: user, user2: user2} do
      user_follow_user = user_follow_user_fixture(%{followed_user_id: user.id, follower_user_id: user2.id})
      assert {:ok, %UserFollowUser{}} = UserFollowUsers.delete_user_follow_user(user_follow_user)
      assert_raise Ecto.NoResultsError, fn -> UserFollowUsers.get_user_follow_user!(user_follow_user.id) end
    end

    test "change_user_follow_user/1 returns a user_follow_user changeset", %{user: user, user2: user2} do
      user_follow_user = user_follow_user_fixture(%{followed_user_id: user.id, follower_user_id: user2.id})
      assert %Ecto.Changeset{} = UserFollowUsers.change_user_follow_user(user_follow_user)
    end
  end
end
