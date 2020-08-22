defmodule Cocu.Projects do
  @moduledoc """
  The Projects context.
  """

  import Ecto.Query, warn: false
  alias Cocu.Repo

  alias Cocu.Projects.Project
  alias Cocu.Communities.Community
  alias Cocu.Categories.Category

  @doc """
  Returns the list of project.

  ## Examples

      iex> list_project()
      [%Project{}, ...]

  """
  def list_project do
    Repo.all(Project)
  end

  @doc """
  Gets a single project.

  Raises `Ecto.NoResultsError` if the Project does not exist.

  ## Examples

      iex> get_project!(123)
      %Project{}

      iex> get_project!(456)
      ** (Ecto.NoResultsError)

  """
  def get_project!(id), do: Repo.get!(Project, id)

  def get_project(id), do: Repo.get(Project, id)

  @doc """
  Creates a project.

  ## Examples

      iex> create_project(%{field: value})
      {:ok, %Project{}}

      iex> create_project(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_project(attrs \\ %{}) do
     %Project{}
     |> Project.changeset(attrs)
     |> Repo.insert()
  end

  @doc """
  Updates a project.

  ## Examples

      iex> update_project(project, %{field: new_value})
      {:ok, %Project{}}

      iex> update_project(project, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_project(%Project{} = project, attrs) do
    project
    |> Project.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Project.

  ## Examples

      iex> delete_project(project)
      {:ok, %Project{}}

      iex> delete_project(project)
      {:error, %Ecto.Changeset{}}

  """
  def delete_project(%Project{} = project) do
    Repo.delete(project)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking project changes.

  ## Examples

      iex> change_project(project)
      %Ecto.Changeset{source: %Project{}}

  """
  def change_project(%Project{} = project) do
    Project.changeset(project, %{})
  end

  def get_projects_by_user(id) do
    query = from project in "project", where: project.founder_id == ^id and project.deleted == false,
    select: map(project, [:id, :vision_name, :inserted_at, :deleted])
    Repo.all(query)
  end

  def get_projects_close_to_deadline(n) do
    query = from project in Project,
      where: project.deleted == false and project.accepted == true,
      order_by: project.fund_limit_date,
      limit: ^n
    
    Repo.all(query)
  end

  def get_all_impact() do
     {:ok, enums} = Repo.query('select enum_range(null::project_impact) as name')
     Enum.concat(enums.rows)
  end

  def get_project_posts(id) do
    alias Cocu.ProjectPosts.ProjectPost
    alias Cocu.Posts.Post
    alias Cocu.Users.User

    query = from post in Post,
              join: pp in ProjectPost, on: pp.post_id == post.id,
              join: usr in User, on: usr.id == pp.user_id,
              where: pp.project_id == ^id,
              select: %{project_post_id: pp.id, post_id: post.id, title: post.title, user_id: usr.id, user_name: usr.name,date: post.inserted_at}

    Repo.all(query)
  end
  
  def get_projects_explorer(name) do 
    query = from project in Project, 
    left_join: category in "category", on: category.id == project.category_id, 
    left_join: media in "media", on: media.project_id == project.id, 
    where: like(project.name, ^name), 
    select:  %{id: project.id, vision: project.vision, vision_name: project.vision_name, fund_asked: project.fund_asked, current_fund: project.current_fund, impact: project.impact, state: project.state, category: category.name, photo: media.image_path} 
    Repo.all(query) 
  end 

  @doc """
  Creates the common part for all the explore queries and then adds the relevant order_by instruction
  """
  def get_query(state, impact, categories, communities, name, order) do
    categories = get_categories_if_empty(categories)
    communities = get_communities_if_empty(communities)
    state = get_states_if_empty(state)
    impact = get_impacts_if_empty(impact)
    name = name <> "%"
    
    subquery = 
      from project in "project", 
      left_join: category in "category", on: category.id == project.category_id,
      left_join: media in "media", on: media.project_id == project.id,
      distinct: project.id,
      where: project.state in ^state and project.impact in ^impact  and (project.community_id in ^communities) and (project.category_id in ^categories) and project.deleted == false and project.accepted == true,
      where: like(project.vision_name, ^name),
      select:  %{id: project.id, vision: project.vision, vision_name: project.vision_name, fund_asked: project.fund_asked, fund_limit_date: project.fund_limit_date,
        karma: project.karma, current_fund: project.current_fund, impact: project.impact, state: project.state, category: category.name, photo: media.image_path,
        inserted_at: project.inserted_at} 

    query = case order do 
      :nearing_deadline -> from project in subquery(subquery), order_by: [asc: project.fund_limit_date]  
      :popularity -> from project in subquery(subquery), order_by: [desc: project.karma]
      :newest -> from project in subquery(subquery), order_by: [desc: project.inserted_at]  
      :most_funded -> from project in subquery(subquery), order_by: [desc: project.current_fund]
      _  -> subquery
    end
    query
  end

  @doc """
  Fetches all projects using the filters
  """
  def get_projects_by_filters(state, impact, categories, communities, name, order) do
    get_query(state, impact, categories, communities, name, order)
      |> Repo.all() 
      |> do_time_mapping(order)
  end

  @doc """
  Fetches n_entries projects by an offset using the filters
  """
  def get_projects_by_filters(state, impact, categories, communities, name, order, n_entries, offset) do
    subquery = get_query(state, impact, categories, communities, name, order)
    query = from project in subquery(subquery),
      offset: ^offset,
      limit: ^n_entries
    Repo.all(query) |> do_time_mapping(order)
  end

  def do_time_mapping(projects, order) do
      Enum.flat_map(projects, fn r-> [elem(Map.get_and_update(r, :inserted_at, fn x -> {x, Timex.to_unix(x)} end), 1)] end)
        |> Enum.flat_map(fn (r) -> [elem(Map.get_and_update( r, :fund_limit_date, fn (x) -> {x, Timex.to_unix(x)} end), 1)] end)
  end
    
  def get_project_photos(id) do
    query = from media in "media", 
    where: media.project_id == ^id,
    select: media.image_path
    Repo.all(query)
  end

  defp get_categories_if_empty(categories)do
      case categories do
        [] -> 
          Repo.all(from(c in Category, select: c.id))
        _ -> categories
      end
  end

  defp get_communities_if_empty(communities)do
      case communities do
        [] -> 
          Repo.all(from(c in Community, select: c.id))
        _ -> communities
      end
  end

  defp get_states_if_empty(state)do
      case state do
        [] -> Repo.all(from(p in Project, distinct: p.state, select: p.state))
        _ -> state
      end
  end

  defp get_impacts_if_empty(impact)do
      case impact do
        [] -> Repo.all(from(p in Project, distinct: p.impact, select: p.impact))
        _ -> impact 
      end
  end

  def get_n_by_community_with_offset(community_id, n, offset) do
    query = from p in Project,
      where: p.community_id == ^community_id and p.accepted == true and p.deleted == false,
      limit: ^n,
      offset: ^offset,
      order_by: [desc: p.updated_at],
      select: %{project_id: p.id, vision_name: p.vision_name}
    Repo.all(query)
  end

  def get_projects_by_community(id) do
    query = from project in "project",
    inner_join: media in "media", on: media.project_id == project.id,
    where: project.community_id == ^id and project.accepted == false and project.deleted == false,
    select: %{id: project.id, vision_name: project.vision_name, image_path: media.image_path}
    Repo.all(query)
  end

end
