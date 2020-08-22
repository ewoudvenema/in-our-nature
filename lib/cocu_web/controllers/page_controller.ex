import CocuWeb.Gettext

defmodule CocuWeb.PageController do
  use CocuWeb, :controller
  alias Cocu.Projects
  alias DateTime
  alias Date
  def init(conn, _params) do

    case conn.params["locale"] || get_session(conn, :locale) do
      nil     -> redirect(conn, to: "/en/")
      locale  ->
        Gettext.put_locale(CocuWeb.Gettext, locale)
        conn |> put_session(:locale, locale)
        redirect(conn, to: "/" <> to_string(get_session(conn, :locale)) <> "/")
    end

  end

  def index(conn, _params) do
    projects_close_deadline = Projects.get_projects_close_to_deadline(3)
    render(conn, "index.html", projects_close_deadline: projects_close_deadline, page_title: "Welcome to Cocu")
  end

  def explore(conn, _params) do
    render(conn, "explore.html")
  end

end
