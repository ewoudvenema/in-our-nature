defmodule CocuWeb.LayoutView do
  use CocuWeb, :view

  @doc """
  Generates name for the JavaScript view we want to use
  in this combination of view/template.
  """
  def js_view_name(conn) do
    [view_name(conn)]
    |> Enum.reverse
    |> List.insert_at(0, "view")
    |> Enum.map(&String.capitalize/1)
    |> Enum.reverse
    |> Enum.join("")
  end

  # Takes the resource name of the view module and removes the
  # the ending *_view* string.
  defp view_name(conn) do
    conn
    |> view_module
    |> Phoenix.Naming.resource_name
    |> String.replace("_view", "")
  end

  defp get_locale(conn) do
    conn
    |> Plug.Conn.get_session(:locale)
  end

  @doc """
  Fetches the communities the user is subscribed to
  """
  def list_user_communities(user_id) do
    user_id
    |> Cocu.CommunityUsers.get_user_communities 
  end

  def display_user_community([id, name]) do
    ~e"""
    <a class="item" href="/community/<%=id%>"><%=name%></a>
    """
  end

  def get_notification_count(user_id) do
    Cocu.CommunityInvitations.get_invite_count user_id
  end
  
end
