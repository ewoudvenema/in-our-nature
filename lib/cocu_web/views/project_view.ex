defmodule CocuWeb.ProjectView do
  use CocuWeb, :view
  alias Cocu.Categories
  alias Cocu.Users
  alias Cocu.Medias

  def getCategoryName(id) do
    Categories.get_category_name_by_id(id)
  end

  def getUsername(id) do
    Users.get_username_by_id(id)
  end
  def getUserImage(id) do
    Users.get_image_by_id(id)
  end

  def getUserProfileLink(id) do
    "/user/" <> Integer.to_string(id)
  end

  def getImages(id) do
    medias = Medias.get_media_by_project(id)
    medias
  end
end
