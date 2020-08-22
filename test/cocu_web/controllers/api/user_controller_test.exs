defmodule CocuWeb.UserApiController do
  use CocuWeb.ConnCase

  alias Cocu.Users
  alias Cocu.Auth.Guardian

  def fixture(:user) do
      {:ok, user} = Users.create_user(
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
      %{user: user}
  end

  def guardian_login(conn, user) do
      bypass_through(conn, CocuWeb.Router, [:browser])
          |> get("/user")
          |> Guardian.Plug.sign_in(user)
          |> send_resp(200, "Flush the session yo")
          |> recycle()
  end

  describe "User Api tests" do
    setup [:create_user]

    test "delete user", %{conn: conn, user: user} do

      conn = guardian_login(conn, user)

      assert user.deleted == false

      route = Enum.join(["/api/v1/user/", user.id, "/deleted/true"], "")
      
      response = put conn, route

      assert json_response(response, 200)

      deleted_user = Users.get_user!(user.id)

      assert deleted_user.deleted == true
      
    end
  end

  defp create_user(_) do
    %{user: user} = fixture(:user)
    {:ok, user: user}
  end

end