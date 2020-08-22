defmodule CocuWeb.HomepageTest do
  use CocuWeb.FeatureCase, async: true

 # import Wallaby.Query, only: [css: 2]
 # import Wallaby.Browser


  #test "Cocu description", %{session: session} do
  #  text = "A world where everyone can follow their passion and propose projects that make the world a more beautiful place."
  #  session
  #  |> visit("/")
  #  |> assert_has(css(".description", text: text))
  #end

  # test "Nearly deadline title", %{session: session} do
  #   text = "NEARLY DEADLINE"
  #   session
  #   |> visit("/")
  #   |> assert_has(css(".nearly-deadline-title", text: text))
  # end

  # test "Nearly deadline projects", %{session: session} do
  #   session
  #   |> visit("/")
  #   |> find(css(".project", count: 3))
  # end

  # test "Communities title", %{session: session} do
  #   text = "YOU MAY BE INTERESTED IN"
  #   session
  #   |> visit("/")
  #   |> assert_has(css(".categories-title", text: text))
  # end

  # test "Communities number", %{session: session} do
  #   session
  #   |> visit("/")
  #   |> find(css(".categories > div > .column", count: 6))
  # end

  # test "Our mission title", %{session: session} do
  #   text = "OUR MISSION"
  #   session
  #   |> visit("/")
  #   |> assert_has(css(".our-mission-title", text: text))
  # end

  # test "Our mission", %{session: session} do
  #   session
  #   |> visit("/")
  #   |> find(css(".goal", count: 3))
  # end

end
