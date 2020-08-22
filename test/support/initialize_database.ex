defmodule CocuWeb.InitializeDatabase do

  alias Cocu.Projects
  alias Cocu.Users
  alias Cocu.Categories

  def init() do
    {:ok, user} = create_user()
    {:ok, category} = create_category()
    {:ok, project} = create_project(user, category)

    %{project_id: project.id}
  end

  def create_category() do
    category_params = %{name: "Test"}
    Categories.create_category(category_params)
  end

  def create_user() do
    user_params = %{
      username: "Test",
      email: "test@test.com",
      password: "test",
      date_of_birth: DateTime.utc_now(),
      name: "Testing Test",
      privileges_level: "user"
    }

    Users.create_user(user_params)
  end

  def create_project(user, category) do
    project_params = %{
      vision_name: "Test Vision Name",
      planning: "Test Planning",
      vision: "Test Vision",
      benefits: "Test Benefits",
      fund_asked: 15000,
      fund_limit_date: DateTime.from_unix!(2147483647),
      website: "http://www.test.com",
      current_fund: 1000,
      state: "creation",
      founder_id: user,
      category_id: category
    }

    Projects.create_project(project_params)
  end
end
