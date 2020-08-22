defmodule CocuWeb.ProjectControllerApiTest do
    use CocuWeb.ConnCase
    alias Cocu.Users
    alias Cocu.Auth.Guardian
    alias Cocu.Communities
    alias Cocu.Projects
    alias Cocu.Categories
    alias Cocu.CommunityUsers

    def fixture(:manage) do
        {:ok, category} = Categories.create_category(%{name: "some category"})
        {:ok, user} = Users.create_user(
          %{
            date_of_birth: ~D[2010-04-17],
            email: "user",
            name: "some name",
            password: "some password",
            picture_path: "some picture_path",
            privileges_level: "user",
            username: "some username"
          }
        )
        {:ok, community} = Communities.create_community(%{description: "some description", is_group: true, name: "some name", picture_path: "some picture_path", founder_id: user.id})
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
        %{user: user, project: project}
    end

    def guardian_login(conn, user) do
        bypass_through(conn, CocuWeb.Router, [:browser])
          |> get("/user")
          |> Guardian.Plug.sign_in(user)
          |> send_resp(200, "Flush the session yo")
      end

    describe "project controller" do
        setup [:create_project]

        test "change project state", %{conn: conn, user: user, project: project} do
            conn = guardian_login(conn, user)

            route = Enum.join(["/api/v1/project/", project.id, "/state/creation" ], "")
        
            response = put conn, route    
            {_, response_body} = Poison.decode(response.resp_body)
            
            assert json_response(response, 200)

            new_project = Projects.get_project!(project.id)

            assert new_project.state == "creation"
        end


        test "delete project", %{conn: conn, user: user, project: project} do
          conn = guardian_login(conn, user)

          route = Enum.join(["api/v1/project/", project.id, "/deleted/true"], "")
      
          response = put conn, route   
          {_, response_body} = Poison.decode(response.resp_body)

          assert json_response(response, 200)

          new_project = Projects.get_project!(project.id)

          assert new_project.deleted == true
          
      end

    end
    

  
    defp create_project(_) do
        %{user: user, project: project} = fixture(:manage)
        {:ok, user: user, project: project}
      end
end
  