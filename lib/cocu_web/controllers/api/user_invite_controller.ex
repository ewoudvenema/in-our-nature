defmodule CocuWeb.V1.UserInviteController do

    use CocuWeb, :controller
    alias Cocu.CommunityInvitations
    alias Cocu.CommunityUsers

    def invite_user_to_community(conn, params) do

        inviter_id = Guardian.Plug.current_resource(conn).id
        # gets a map with the user's name, id, email, and error message ("none" if there are no problems)
        # if there is an error, a map with an error message is returned
        user = Cocu.Users.get_user_by_email(params["invitee_info"])
        case user["status"] do
            "ok" -> status = create_user_invitation(inviter_id, user[:user_id], params["community_id"])
                    json(conn, %{"status": status})
            _ -> json(conn, user)
        end
    end

    defp create_user_invitation(inviter_id, invitee_id, community_id) do
        list = CommunityUsers.user_follows_community(invitee_id, community_id)
        if not Enum.empty?(list) do     # user already follows this community
            "user already follows this community"
        else 
            {status, _} = CommunityInvitations.create_community_invitation(%{inviter_id: inviter_id, invited_id: invitee_id, community_id: community_id})        
            status
        end
    end
end