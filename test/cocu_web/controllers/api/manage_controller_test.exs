defmodule CocuWeb.ManageApiTest do
    use CocuWeb.ConnCase
    alias Cocu.Users
    alias Cocu.Auth.Guardian
    alias Cocu.Communities
    alias Cocu.Projects
    alias Cocu.Categories
    alias Cocu.CommunityUsers

    def fixture(:manage) do
        {:ok, category} = Categories.create_category(%{name: "some category"})
        {:ok, user1} = Users.create_user(
          %{
            date_of_birth: ~D[2010-04-17],
            email: "user1",
            name: "some name",
            password: "some password",
            picture_path: "some picture_path",
            privileges_level: "user",
            username: "some username"
          }
        )
        {:ok, community} = Communities.create_community(%{description: "some description", is_group: true, name: "some name", picture_path: "some picture_path", founder_id: user1.id})
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
            founder_id: user1.id,
            community_id: community.id,
            location: "Porto",
            impact: "global"
          }
        )
        %{user1: user1, project: project, community: community}
    end

    def guardian_login(conn, user) do
        bypass_through(conn, CocuWeb.Router, [:browser])
          |> get("/user")
          |> Guardian.Plug.sign_in(user)
          |> send_resp(200, "Flush the session yo")
          |> recycle()
      end

    describe "manage controller" do
        setup [:create_project]

        test "get community projects by id", %{conn: conn, user1: user1, project: project, community: community} do

            conn = guardian_login(conn, user1)

            route = Enum.join(["/api/v1/manage/projects?id=", community.id], "")
        
            response = get conn, route    
            {_, response_body} = Poison.decode(response.resp_body)

            Enum.each response_body, fn project_response -> 
                project = Projects.get_project!(project_response["id"])
                assert project.community_id == community.id
            end
        end

        test "get user communities", %{conn: conn, user1: user1, project: project, community: community} do
            
            conn = guardian_login(conn, user1)
            route = "/api/v1/manage/communities"
            response = get conn, route    
            {_, response_body} = Poison.decode(response.resp_body)

            assert Enum.empty?(response_body) == false
        end

        test "accept project", %{conn: conn, user1: user1, project: project, community: community} do
            
            conn = guardian_login(conn, user1)

            route = Enum.join(["/api/v1/manage/updateAcceptance/?id=", project.id], "")

            response = put conn, route    
            {_, response_body} = Poison.decode(response.resp_body)

            assert response_body["message"] == "Success"
        end

    end
    

  
    defp create_project(_) do
        %{user1: user1, project: project, community: community} = fixture(:manage)
        {:ok, user1: user1, project: project, community: community}
      end
end
  