defmodule Cocu.CommunitiesTest do
  use Cocu.DataCase

  alias Cocu.Communities
  alias Cocu.Users

  describe "community" do
    alias Cocu.Communities.Community

    @valid_attrs %{
      description: "some description",
      is_group: true,
      name: "some name",
      picture_path: "some picture_path"
    }
    @update_attrs %{
      description: "some updated description",
      is_group: false,
      name: "some updated name",
      picture_path: "some updated picture_path"
    }
    @invalid_attrs %{description: nil, is_group: nil, name: nil, picture_path: nil}

    defp create_user() do
      Users.create_user(
        %{
          date_of_birth: ~D[2010-04-17],
          email: "some email",
          name: "some name",
          password: "some password",
          picture_path: "some picture_path",
          privileges_level: "user",
          username: "some username"
        }
      )
    end

    defp community_fixture(attrs \\ %{}) do
      {:ok, user} = create_user()
      community_attrs = Map.merge(@valid_attrs, %{founder_id: user.id})

      {:ok, community} =
        attrs
        |> Enum.into(community_attrs)
        |> Communities.create_community()

      community
    end

    test "list_community/0 returns all community" do
      communities = Communities.list_community()
      community = community_fixture()
      communities = communities ++ [community]
      assert (Communities.list_community() -- communities) == []
    end

    test "get_community!/1 returns the community with given id" do
      community = community_fixture()
      assert Communities.get_community!(community.id) == community
    end

    test "create_community/1 with valid data creates a community" do
      {:ok, user} = create_user()
      community_attrs = Map.merge(@valid_attrs, %{founder_id: user.id})
      assert {:ok, %Community{} = community} = Communities.create_community(community_attrs)
      assert community.description == "some description"
      assert community.is_group == true
      assert community.name == "some name"
      assert community.picture_path == "some picture_path"
    end

    test "create_community/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Communities.create_community(@invalid_attrs)
    end

    test "update_community/2 with valid data updates the community" do
      community = community_fixture()
      assert {:ok, community} = Communities.update_community(community, @update_attrs)
      assert %Community{} = community
      assert community.description == "some updated description"
      assert community.is_group == false
      assert community.name == "some updated name"
      assert community.picture_path == "some updated picture_path"
    end

    test "update_community/2 with invalid data returns error changeset" do
      community = community_fixture()
      assert {:error, %Ecto.Changeset{}} = Communities.update_community(community, @invalid_attrs)
      assert community == Communities.get_community!(community.id)
    end

    test "delete_community/1 deletes the community" do
      community = community_fixture()
      assert {:ok, %Community{}} = Communities.delete_community(community)
      assert_raise Ecto.NoResultsError, fn -> Communities.get_community!(community.id) end
    end

    test "change_community/1 returns a community changeset" do
      community = community_fixture()
      assert %Ecto.Changeset{} = Communities.change_community(community)
    end
  end
end
