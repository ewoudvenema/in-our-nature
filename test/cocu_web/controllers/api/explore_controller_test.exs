defmodule CocuWeb.ExploreApiTest do
    use CocuWeb.ConnCase

    alias Cocu.Categories
    alias Cocu.Users
    alias Cocu.Communities
    alias Cocu.Projects
    alias Cocu.Auth.Guardian
  
    def fixture(:explore) do
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
          |> recycle()
    end

    describe "ExploreProject" do
        setup [:create_project]

        test "explore project by name", %{conn: conn, user: user, project: project} do
            conn = guardian_login(conn, user)

            name = String.replace( project.vision_name , " " , "%20")
            route = Enum.join(["/api/v1/explore/?name=", name, "&page=0"], "")
            response = get conn, route
            
            {_, response_body} = Poison.decode(response.resp_body)

           Enum.each response_body, fn project_response -> 
            assert String.contains?(project_response["vision_name"], project.vision_name)
          end

        end

        test "explore project by impact", %{conn: conn, user: user, project: project} do
            conn = guardian_login(conn, user)

            route = "/api/v1/explore/?order=&impact%5B%5D=global&name=&page=0"
            response = get conn, route
             {_, response_body} = Poison.decode(response.resp_body)
            Enum.each response_body, fn project_response -> 
                project_response["impact"] == "global"
            end
        end

        test "explore project by state", %{conn: conn, user: user, project: project} do
            conn = guardian_login(conn, user)

            route = "/api/v1/explore?order=&state%5B%5D=funding&name=&page=0"
            response = get conn, route
             {_, response_body} = Poison.decode(response.resp_body)
            
            Enum.each response_body, fn project_response -> 
                project_response["state"] == "funding"
            end
        end


        test "explore project by category", %{conn: conn, user: user, project: project} do
            conn = guardian_login(conn, user)

            route = Enum.join(["/api/v1/explore?order=&state%5B%5D=presentation&state%5B%5D=funding&state%5B%5D=creation&impact%5B%5D=regional&impact%5B%5D=national&impact%5B%5D=international&impact%5B%5D=global&category%5B%5D=", project.category_id, "&name=&page=0"], "")
            response = get conn, route
             {_, response_body} = Poison.decode(response.resp_body)
            
            Enum.each response_body, fn project_response -> 
                project_response["category_id"] == project.category_id
            end
        end 
    end

    defp create_project(_) do
        %{user: user, project: project} = fixture(:explore)
        {:ok, user: user, project: project}
      end
    
end  