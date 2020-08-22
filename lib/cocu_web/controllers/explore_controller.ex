import CocuWeb.Gettext

defmodule CocuWeb.ExploreController do
  use CocuWeb, :controller
  alias Cocu.Projects
  alias DateTime
  alias Date
 
  def index(conn, params) do

    name = 
      case params["name"] do
        nil -> ""
        _ -> params["name"]
      end



    order = 
    case params["order"] do
      nil -> ""
      _ -> params["order"]
    end
    
    render(conn, "index.html", project_search_name: name, project_order: order, page_title: "Explore " <> name)
  end

end
