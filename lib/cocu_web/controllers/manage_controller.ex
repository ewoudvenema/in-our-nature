import CocuWeb.Gettext

defmodule CocuWeb.ManageController do
  use CocuWeb, :controller
  alias Cocu.Users
 
  def index(conn, params) do
    user = Users.get_user!(Guardian.Plug.current_resource(conn).id)
    render(conn, "index.html", user: user)
  end

end
