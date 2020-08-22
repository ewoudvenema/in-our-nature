defmodule CocuWeb.ErrorView do
  use CocuWeb, :view

  def render("404.html", assigns) do
    render("show.html", assigns)
  end

  def render("500.html", assigns) do
    render("show.html", assigns)
  end

  def render("404.json", assigns) do
  render("show.html", assigns)
  end

  def render("422.json", assigns) do
  render("show.html", assigns)
  end

  def render("500.json", assigns) do
  render("show.html", assigns)
  end

  # In case no render clause matches or no
  # template is found, let's render it as 500
  def template_not_found(_template, assigns) do
    render("show.html", assigns)
  end
end
