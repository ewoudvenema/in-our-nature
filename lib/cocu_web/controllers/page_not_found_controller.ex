defmodule CocuWeb.PageNotFoundController do
  use CocuWeb, :controller

  # alias Cocu.Page
  # alias Cocu.Page.PageNotFound
  #
  # def index(conn, _params) do
  #   pagenotfound = Page.list_pagenotfound()
  #   render(conn, "index.html", pagenotfound: pagenotfound)
  # end
  #
  # def create(conn, %{"page_not_found" => page_not_found_params}) do
  #   case Page.create_page_not_found(page_not_found_params) do
  #     {:ok, page_not_found} ->
  #       conn
  #       |> put_flash(:info, "Page not found created successfully.")
  #       |> redirect(to: page_not_found_path(conn, :show, page_not_found))
  #     {:error, %Ecto.Changeset{} = changeset} ->
  #       render(conn, "new.html", changeset: changeset)
  #   end
  # end

  def show(conn, %{}) do
    render(conn, "show.html")
  end

  def error(conn, _params) do
     redirect(conn, to: "/pagenotfound/404")
  end
end
