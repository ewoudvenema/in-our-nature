defmodule CocuWeb.PageNotFoundControllerTest do
  # use CocuWeb.ConnCase

  # alias Cocu.Page

  # @create_attrs %{}
  # @update_attrs %{}
  # @invalid_attrs %{}

  # def fixture(:page_not_found) do
  #   {:ok, page_not_found} = Page.create_page_not_found(@create_attrs)
  #   page_not_found
  # end

  # describe "index" do
  #   test "lists all pagenotfound", %{conn: conn} do
  #     conn = get conn, page_not_found_path(conn, :index)
  #     assert html_response(conn, 200) =~ "Listing Pagenotfound"
  #   end
  # end

  # describe "new page_not_found" do
  #   test "renders form", %{conn: conn} do
  #     conn = get conn, page_not_found_path(conn, :new)
  #     assert html_response(conn, 200) =~ "New Page not found"
  #   end
  # end

  # describe "create page_not_found" do
  #   test "redirects to show when data is valid", %{conn: conn} do
  #     conn = post conn, page_not_found_path(conn, :create), page_not_found: @create_attrs

  #     assert %{id: id} = redirected_params(conn)
  #     assert redirected_to(conn) == page_not_found_path(conn, :show, id)

  #     conn = get conn, page_not_found_path(conn, :show, id)
  #     assert html_response(conn, 200) =~ "Show Page not found"
  #   end

  #   test "renders errors when data is invalid", %{conn: conn} do
  #     conn = post conn, page_not_found_path(conn, :create), page_not_found: @invalid_attrs
  #     assert html_response(conn, 200) =~ "New Page not found"
  #   end
  # end

  # describe "edit page_not_found" do
  #   setup [:create_page_not_found]

  #   test "renders form for editing chosen page_not_found", %{conn: conn, page_not_found: page_not_found} do
  #     conn = get conn, page_not_found_path(conn, :edit, page_not_found)
  #     assert html_response(conn, 200) =~ "Edit Page not found"
  #   end
  # end

  # describe "update page_not_found" do
  #   setup [:create_page_not_found]

  #   test "redirects when data is valid", %{conn: conn, page_not_found: page_not_found} do
  #     conn = put conn, page_not_found_path(conn, :update, page_not_found), page_not_found: @update_attrs
  #     assert redirected_to(conn) == page_not_found_path(conn, :show, page_not_found)

  #     conn = get conn, page_not_found_path(conn, :show, page_not_found)
  #     assert html_response(conn, 200)
  #   end

  #   test "renders errors when data is invalid", %{conn: conn, page_not_found: page_not_found} do
  #     conn = put conn, page_not_found_path(conn, :update, page_not_found), page_not_found: @invalid_attrs
  #     assert html_response(conn, 200) =~ "Edit Page not found"
  #   end
  # end

  # describe "delete page_not_found" do
  #   setup [:create_page_not_found]

  #   test "deletes chosen page_not_found", %{conn: conn, page_not_found: page_not_found} do
  #     conn = delete conn, page_not_found_path(conn, :delete, page_not_found)
  #     assert redirected_to(conn) == page_not_found_path(conn, :index)
  #     assert_error_sent 404, fn ->
  #       get conn, page_not_found_path(conn, :show, page_not_found)
  #     end
  #   end
  # end

  # defp create_page_not_found(_) do
  #   page_not_found = fixture(:page_not_found)
  #   {:ok, page_not_found: page_not_found}
  # end
end
