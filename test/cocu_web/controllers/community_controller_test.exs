defmodule CocuWeb.CommunityControllerTest do
  use CocuWeb.ConnCase

  alias Cocu.Communities
  alias Cocu.Users
  alias Cocu.Users.User
  alias Cocu.Auth.Guardian

  @create_attrs %{description: "some description", is_group: true, name: "some name"}
  @update_attrs %{description: "some updated description", is_group: false, name: "some updated name"}
  @invalid_attrs %{description: nil, is_group: nil, name: nil}
  @user_attrs %{date_of_birth: ~D[2010-04-17], email: "some email", name: "some name", password: "some password", picture_path: "some picture_path", privileges_level: "user", username: "some username"}

  #{:ok, %User{} = user} = Users.create_user(@user_attrs)

  def fixture(:community) do
    assert {:ok, %User{} = user} = Users.create_user(@user_attrs)
    {:ok, community} = Communities.create_community(Map.merge(@create_attrs, %{founder_id: user.id}))
    community
  end

  def guardian_login(conn, user) do
    bypass_through(conn, CocuWeb.Router, [:browser])
      |> get("/user")
      |> Guardian.Plug.sign_in(user)
      |> send_resp(200, "Flush the session yo")
      |> recycle()
  end

  describe "index" do
    test "lists all community", %{conn: conn} do
      conn = get conn, community_path(conn, :index)
      assert html_response(conn, 200) =~ "Order by"
    end
  end

  describe "new community" do
    test "renders form", %{conn: conn} do
      {:ok, %User{} = user} = Users.create_user(@user_attrs)
      conn = guardian_login(conn, user)
      conn = get conn, community_path(conn, :new)
      assert html_response(conn, 200) =~ "Create Community"
    end
  end

  describe "create community" do
    test "redirects to show when data is valid", %{conn: conn} do
      {:ok, %User{} = user} = Users.create_user(@user_attrs)
      conn = guardian_login(conn, user)
      conn = post conn, community_path(conn, :create), community: Map.merge(@create_attrs, %{founder_id: user.id})

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == community_path(conn, :show, id)

      conn = get conn, community_path(conn, :show, id)
      assert html_response(conn, 200) =~ @create_attrs.name
    end

    test "renders errors when data is invalid", %{conn: conn} do
      {:ok, %User{} = user} = Users.create_user(@user_attrs)
      conn = guardian_login(conn, user)
      conn = post conn, community_path(conn, :create), community: @invalid_attrs
      assert html_response(conn, 200) =~ "Create Community"
    end
  end

  describe "edit community" do
    setup [:create_community]

    test "renders form for editing chosen community", %{conn: conn, community: community} do
      {:ok, %User{} = user} = Users.create_user(%{date_of_birth: ~D[2010-04-17], email: "some email1", name: "some name", password: "some password", picture_path: "some picture_path", privileges_level: "user", username: "some username"})
      conn = guardian_login(conn, user)
      conn = get conn, community_path(conn, :edit, community)
      assert html_response(conn, 200) =~ "Edit Community"
    end
  end

  describe "update community" do
    setup [:create_community]

    test "redirects when data is valid", %{conn: conn, community: community} do
      {:ok, %User{} = user} = Users.create_user(%{date_of_birth: ~D[2010-04-17], email: "some email1", name: "some name", password: "some password", picture_path: "some picture_path", privileges_level: "user", username: "some username"})
      conn = guardian_login(conn, user)
      conn = put conn, community_path(conn, :update, community), community: @update_attrs
      assert redirected_to(conn) == community_path(conn, :show, community)

      conn = get conn, community_path(conn, :show, community)
      assert html_response(conn, 200) =~ "some updated description"
    end

    test "renders errors when data is invalid", %{conn: conn, community: community} do
      {:ok, %User{} = user} = Users.create_user(%{date_of_birth: ~D[2010-04-17], email: "some email1", name: "some name", password: "some password", picture_path: "some picture_path", privileges_level: "user", username: "some username"})
      conn = guardian_login(conn, user)
      conn = put conn, community_path(conn, :update, community), community: @invalid_attrs
      assert html_response(conn, 200) =~ "Edit Community"
    end
  end

  describe "delete community" do
    setup [:create_community]

    test "deletes chosen community", %{conn: conn, community: community} do
      conn = delete conn, community_path(conn, :delete, community)
      assert redirected_to(conn) == community_path(conn, :index)
      assert_error_sent 404, fn ->
        get conn, community_path(conn, :show, community)
      end
    end
  end

  defp create_community(_) do
    community = fixture(:community)
    {:ok, community: community}
  end
end
