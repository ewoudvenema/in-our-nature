defmodule Cocu.Auth.ErrorHandler do
  use CocuWeb, :controller
  
  import Plug.Conn

  
  def auth_error(conn, {type, _reason}, _opts) do
    body = to_string(type)
    conn
    |> put_resp_content_type("text/plain")
    |> put_flash(:warning, "You must first log in.")
    |> redirect(to: user_path(conn, :index))
  end


end