defmodule Cocu.MediasTest do
  use Cocu.DataCase

  alias Cocu.Medias

  describe "media" do
    alias Cocu.Medias.Media

    @valid_attrs %{image_path: "some image_path"}
    @update_attrs %{image_path: "some updated image_path"}
    @invalid_attrs %{image_path: nil}

    def media_fixture(attrs \\ %{}) do
      {:ok, media} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Medias.create_media()

      media
    end

    test "list_media/0 returns all media" do
      media_list = Medias.list_media()
      media = media_fixture()
      media_list  = media_list ++ [media]
      assert Medias.list_media() == media_list
    end

    test "get_media!/1 returns the media with given id" do
      media = media_fixture()
      assert Medias.get_media!(media.id) == media
    end

    test "create_media/1 with valid data creates a media" do
      assert {:ok, %Media{} = media} = Medias.create_media(@valid_attrs)
      assert media.image_path == "some image_path"
    end

    test "create_media/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Medias.create_media(@invalid_attrs)
    end

    test "update_media/2 with valid data updates the media" do
      media = media_fixture()
      assert {:ok, media} = Medias.update_media(media, @update_attrs)
      assert %Media{} = media
      assert media.image_path == "some updated image_path"
    end

    test "update_media/2 with invalid data returns error changeset" do
      media = media_fixture()
      assert {:error, %Ecto.Changeset{}} = Medias.update_media(media, @invalid_attrs)
      assert media == Medias.get_media!(media.id)
    end

    test "delete_media/1 deletes the media" do
      media = media_fixture()
      assert {:ok, %Media{}} = Medias.delete_media(media)
      assert_raise Ecto.NoResultsError, fn -> Medias.get_media!(media.id) end
    end

    test "change_media/1 returns a media changeset" do
      media = media_fixture()
      assert %Ecto.Changeset{} = Medias.change_media(media)
    end
  end
end
