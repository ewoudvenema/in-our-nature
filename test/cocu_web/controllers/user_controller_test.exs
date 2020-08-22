defmodule CocuWeb.UserControllerTest do
  use CocuWeb.ConnCase

  @create_attrs %{date_of_birth: ~D[2010-04-17], email: "some email", name: "some name", password: "some password", picture_path: "some picture_path", password_confirmation: "some updated password", privileges_level: "user"}
  #@update_attrs %{date_of_birth: ~D[2011-05-18], email: "some updated email", name: "some updated name", password: "some updated password", password_confirmation: "some updated password" , picture_path: "some updated picture_path", privileges_level: "user"}
  #@invalid_attrs %{date_of_birth: nil, email: nil, name: nil, password: "some password", password_confirmation: "some password", picture_path: nil, privileges_level: nil}

  def fixture(:user) do
    {:ok, user} = Users.create_user(@create_attrs)
    user
  end

  describe "index" do
    test "shows user log in page when not logged in", %{conn: conn} do
      conn = get conn, user_path(conn, :index)

      assert html_response(conn, 200) =~ "SIGN IN"
    end
  end

  describe "new user" do
     test "renders form", %{conn: conn} do
       conn = get conn, user_path(conn, :new)
       assert html_response(conn, 200) =~ "Please enter your details below"
     end
  end

end
