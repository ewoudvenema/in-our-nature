defmodule Cocu.UsersTest do
  use Cocu.DataCase

  alias Cocu.Users
  alias Comeonin.Bcrypt

  describe "user" do
    alias Cocu.Users.User

    @valid_attrs %{
      date_of_birth: ~D[2010-04-17],
      email: "some email",
      name: "some name",
      password: "some password",
      picture_path: "some picture_path",
      privileges_level: "user",
      username: "some username"
    }
    @update_attrs %{
      date_of_birth: ~D[2011-05-18],
      email: "some updated email",
      name: "some updated name",
      password: "some updated password",
      picture_path: "some updated picture_path",
      privileges_level: "user",
      username: "some updated username"
    }
    @invalid_attrs %{
      date_of_birth: nil,
      email: nil,
      name: nil,
      password: nil,
      picture_path: nil,
      privileges_level: nil,
      username: nil
    }

    def user_fixture(attrs \\ %{}) do
      {:ok, user} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Users.create_user()
      user
    end

    test "list_user/0 returns all user" do
      user_list = Users.list_user()
      user = user_fixture()
      user_list = user_list ++ [user]
      assert (Users.list_user() -- user_list ) == []
    end

    test "get_user!/1 returns the user with given id" do
      user = user_fixture()
      assert Users.get_user!(user.id) == user
    end

    test "create_user/1 with valid data creates a user" do
      assert {:ok, %User{} = user} = Users.create_user(@valid_attrs)
      assert user.date_of_birth == ~D[2010-04-17]
      assert user.email == "some email"
      assert user.name == "some name"
      assert Bcrypt.checkpw("some password", user.password)
      assert user.picture_path == "some picture_path"
      assert user.privileges_level == "user"
    end

    test "create_user/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Users.create_user(@invalid_attrs)
    end

    test "update_user/2 with valid data updates the user" do
      user = user_fixture()
      assert {:ok, user} = Users.update_user(user, @update_attrs)
      assert %User{} = user
      assert user.date_of_birth == ~D[2011-05-18]
      assert user.email == "some updated email"
      assert user.name == "some updated name"
      assert Bcrypt.checkpw("some updated password", user.password)
      assert user.picture_path == "some updated picture_path"
      assert user.privileges_level == "user"
    end

    test "update_user/2 with invalid data returns error changeset" do
      user = user_fixture()
      assert {:error, %Ecto.Changeset{}} = Users.update_user(user, @invalid_attrs)
      assert user == Users.get_user!(user.id)
    end

    test "delete_user/1 deletes the user" do
      user = user_fixture()
      assert {:ok, %User{}} = Users.delete_user(user)
      assert_raise Ecto.NoResultsError, fn -> Users.get_user!(user.id) end
    end

    test "change_user/1 returns a user changeset" do
      user = user_fixture()
      assert %Ecto.Changeset{} = Users.change_user(user)
    end
  end
end
