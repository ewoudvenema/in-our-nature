defmodule CocuWeb.CommunityApiTest do
    use CocuWeb.ConnCase

    alias Cocu.Categories
    alias Cocu.Users
    alias Cocu.Communities
    alias Cocu.Projects
    alias Cocu.Auth.Guardian

    def fixture(:community) do
        {:ok, category} = Categories.create_category(%{name: "some category"})
        {:ok, user} = Users.create_user(
          %{
            date_of_birth: ~D[2010-04-17],
            email: "some email",
            name: "some name",
            password: "some password",
            picture_path: "some picture_path",
            privileges_level: "user",
            username: "some username"
          }
        )
        {:ok, community} = Communities.create_community(%{description: "some description", is_group: true, name: "some", picture_path: "some picture_path", founder_id: user.id})
        {:ok, project} = Projects.create_project(
          %{
            benefits: "some benefits",
            current_fund: 120.5,
            fund_asked: 120.5,
            fund_limit_date: ~D[2010-04-17],
            planning: "some planning",
            state: "funding",
            vision: "some vision",
            vision_name: "some vision_name",
            website: "some website",
            category_id: category.id,
            founder_id: user.id,
            community_id: community.id,
            location: "Porto",
            impact: "global"
          }
        )
        %{user: user, community: community}
    end

    def guardian_login(conn, user) do
        bypass_through(conn, CocuWeb.Router, [:browser])
          |> get("/user")
          |> Guardian.Plug.sign_in(user)
          |> send_resp(200, "Flush the session yo")
          |> recycle()
    end

    describe "community controller tests" do
        setup [:create_community]

        test "explore community by name", %{conn: conn, user: user, community: community} do
            conn = guardian_login(conn, user)

            name = String.replace(community.name, " " , "%20")
            name_url = Enum.join(["%25", name, "%25"], "")
            
            route = Enum.join(["/api/v1/communities?name=", name_url, "&order=&page=0"], "")
            response = get conn, route
            {_, response_body} = Poison.decode(response.resp_body)

            Enum.each response_body, fn community_response -> 
                assert String.contains?(community_response["name"], community.name)
            end

        end

        test "delete community", %{conn: conn, user: user, community: community} do
            conn = guardian_login(conn, user)
            route = Enum.join(["api/v1/community/delete/", community.id], "")
            response = delete conn, route
            assert json_response(response, 200)
        end

        test "get n projects", %{conn: conn, user: user, community: community} do
            conn = guardian_login(conn, user)
            route = Enum.join(["api/v1/community/get_n_projects?community_id=", community.id, "&page=0"], "")
            response = get conn, route
            {_, response_body} = Poison.decode(response.resp_body)

            Enum.each response_body["projects"], fn project_response -> 
                project = Projects.get_project!(project_response["project_id"])
                assert project.community_id == community.id
            end
        end
    end

    defp create_community(_) do
        %{user: user, community: community} = fixture(:community)
        {:ok, user: user, community: community}
    end
  
end  