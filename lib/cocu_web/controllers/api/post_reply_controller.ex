defmodule CocuWeb.V1.PostReplyController do
    
        use CocuWeb, :controller
    
        def addPostReply(conn, params) do
            {user_id, _} = Integer.parse(params["user_id"])

            if Guardian.Plug.current_resource(conn).id == user_id do
                case Cocu.PostReplies.create_post_reply(params) do
                    {:ok, %Cocu.PostReplies.PostReply{id: id, content: content, inserted_at: date, user_id: userId}} -> 
                        json(conn, %{id: id, replyId: id, date: date, content: content, userId: userId, username: Guardian.Plug.current_resource(conn).name})
                    {:error, _} -> json(conn, %{message: "error"})
                end
            else
                json(conn, %{message: "error"})
            end          
        end

        def getPostReplyById(conn, params) do
            reply = Cocu.Repo.get!(Cocu.PostReplies.PostReply, params["id"])
            json(conn, %{id: reply.id, content: reply.content, insert_at: reply.inserted_at})
        end

        def deletePostReply(conn, params) do
            reply = Cocu.Repo.get!(Cocu.PostReplies.PostReply, params["id"])
            case Cocu.Repo.delete(reply) do
                {:ok, _} -> json(conn, %{message: "sucess"})
                _ -> json(conn, %{message: "error"})
            end
        end

        def editPostReply(conn, params) do
            postReply = Cocu.Repo.get_by(Cocu.PostReplies.PostReply, id: params["id"])

            if Guardian.Plug.current_resource(conn).id == postReply.user_id do
                reply = Ecto.Changeset.change postReply, content: params["reply_content"]
                case Cocu.Repo.update(reply) do
                    {:ok, _} -> json(conn, %{message: "sucess"})
                    _ -> json(conn, %{message: "error"})
                end
            end
        end

    end