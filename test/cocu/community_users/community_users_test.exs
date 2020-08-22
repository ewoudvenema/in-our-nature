defmodule Cocu.CommunityUsersTest do
  use Cocu.DataCase

  alias Cocu.CommunityUsers
  alias Cocu.Users
  alias Cocu.Users.User
  alias Cocu.Communities
  alias Cocu.Communities.Community

  describe "community_user" do
    alias Cocu.CommunityUsers.CommunityUser

    @valid_attrs %{}
    @invalid_attrs %{user_id: nil, community_id: nil}
    @user_attrs %{date_of_birth: ~D[2010-04-17], email: "some email", name: "some name", password: "some password", picture_path: "some picture_path", privileges_level: "user", username: "some username"}
    @user2_attrs %{date_of_birth: ~D[2010-04-17], email: "some email2", name: "some name", password: "some password", picture_path: "some picture_path", privileges_level: "user", username: "some username2"}
    @community_attrs %{description: "some description", is_group: true, name: "some name", picture_path: "some picture_path"}

    setup do
      assert {:ok, %User{} = user} = Users.create_user(@user_attrs)
      assert {:ok, %Community{} = community} = Communities.create_community(Map.merge(@community_attrs, %{founder_id: user.id}))
      assert {:ok, %User{} = user2} = Users.create_user(@user2_attrs)

      {:ok, %{user: user, community: community, user2: user2}}
    end

    def community_user_fixture(attrs \\ %{}) do
      {:ok, community_user} =
        attrs
        |> Enum.into(@valid_attrs)
        |> CommunityUsers.create_community_user()

      community_user
    end

    test "list_community_user/0 returns all community_user", %{user: user, community: community} do
      users = CommunityUsers.list_community_user()
      community_user = community_user_fixture(%{user_id: user.id, community_id: community.id})
      users = users ++ [community_user]
      assert (CommunityUsers.list_community_user() -- users) == []
    end

    test "get_community_user!/1 returns the community_user with given id", %{user: user, community: community} do
      community_user = community_user_fixture(%{user_id: user.id, community_id: community.id})
      assert CommunityUsers.get_community_user!(community_user.id) == community_user
    end

    test "create_community_user/1 with valid data creates a community_user", %{user: user, community: community} do
      assert {:ok, %CommunityUser{} = community_user } = CommunityUsers.create_community_user(%{user_id: user.id, community_id: community.id})
      assert community_user.user_id == user.id
    end

    test "create_community_user/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = CommunityUsers.create_community_user(@invalid_attrs)
    end

    test "update_community_user/2 with valid data updates the community_user", %{user: user, community: community, user2: user2} do
      community_user = community_user_fixture(%{user_id: user.id, community_id: community.id})
      assert {:ok, community_user} = CommunityUsers.update_community_user(community_user, %{user_id: user2.id, community_id: community.id})
      assert %CommunityUser{} = community_user
    end

    test "update_community_user/2 with invalid data returns error changeset", %{user: user, community: community} do
      community_user = community_user_fixture(%{user_id: user.id, community_id: community.id})
      assert {:error, %Ecto.Changeset{}} = CommunityUsers.update_community_user(community_user, @invalid_attrs)
      assert community_user == CommunityUsers.get_community_user!(community_user.id)
    end

    test "delete_community_user/1 deletes the community_user", %{user: user, community: community} do
      community_user = community_user_fixture(%{user_id: user.id, community_id: community.id})
      assert {:ok, %CommunityUser{}} = CommunityUsers.delete_community_user(community_user)
      assert_raise Ecto.NoResultsError, fn -> CommunityUsers.get_community_user!(community_user.id) end
    end

    test "change_community_user/1 returns a community_user changeset", %{user: user, community: community} do
      community_user = community_user_fixture(%{user_id: user.id, community_id: community.id})
      assert %Ecto.Changeset{} = CommunityUsers.change_community_user(community_user)
    end
  end
end
