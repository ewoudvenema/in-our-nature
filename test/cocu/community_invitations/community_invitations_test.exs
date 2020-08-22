defmodule Cocu.CommunityInvitationsTest do
  use Cocu.DataCase

  alias Cocu.CommunityInvitations
  alias Cocu.Users
  alias Cocu.Users.User
  alias Cocu.Communities
  alias Cocu.Communities.Community

  describe "community_invitations" do
    alias Cocu.CommunityInvitations.CommunityInvitation

    @valid_attrs %{}
    @update_attrs %{}
    @invalid_attrs %{inviter_id: nil, invited_id: nil, community_id: nil}
    @user_attrs %{date_of_birth: ~D[2010-04-17], email: "some email", name: "some name", password: "some password", picture_path: "some picture_path", privileges_level: "user", username: "some username"}
    @user_attrs2 %{date_of_birth: ~D[2010-04-17], email: "some email2", name: "some name2", password: "some password", picture_path: "some picture_path", privileges_level: "user", username: "some username2"}
    @community_attrs %{description: "some description", is_group: true, name: "some name", picture_path: "some picture_path"}
    
    
    setup do
      assert {:ok, %User{} = user} = Users.create_user(@user_attrs)
      assert {:ok, %User{} = user2} = Users.create_user(@user_attrs2)
      assert {:ok, %Community{} = community} = Communities.create_community(Map.merge(@community_attrs, %{founder_id: user.id}))
      {:ok, %{user: user, user2: user2, community: community}}      
    end

    def community_invitation_fixture(attrs \\ %{}) do
      {:ok, community_invitation} =
        attrs
        |> Enum.into(@valid_attrs)
        |> CommunityInvitations.create_community_invitation()

      community_invitation
    end

    test "list_community_invitations/0 returns all community_invitations", %{user: user, user2: user2, community: community} do
      community_invitation = community_invitation_fixture(%{inviter_id: user.id, invited_id: user2.id, community_id: community.id})
      assert CommunityInvitations.list_community_invitations() == [community_invitation]
    end

    test "get_community_invitation!/1 returns the community_invitation with given id", %{user: user, user2: user2, community: community} do
      community_invitation = community_invitation_fixture(%{inviter_id: user.id, invited_id: user2.id, community_id: community.id})
      assert CommunityInvitations.get_community_invitation!(community_invitation.id) == community_invitation
    end

    test "create_community_invitation/1 with valid data creates a community_invitation", %{user: user, user2: user2, community: community} do
      assert {:ok, %CommunityInvitation{}} = CommunityInvitations.create_community_invitation(%{inviter_id: user.id, invited_id: user2.id, community_id: community.id})
    end

    test "create_community_invitation/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = CommunityInvitations.create_community_invitation(@invalid_attrs)
    end

    test "update_community_invitation/2 with valid data updates the community_invitation", %{user: user, user2: user2, community: community} do
      community_invitation = community_invitation_fixture(%{inviter_id: user.id, invited_id: user2.id, community_id: community.id})
      assert {:ok, community_invitation} = CommunityInvitations.update_community_invitation(community_invitation, @update_attrs)
      assert %CommunityInvitation{} = community_invitation
    end

    test "update_community_invitation/2 with invalid data returns error changeset", %{user: user, user2: user2, community: community} do
      community_invitation = community_invitation_fixture(%{inviter_id: user.id, invited_id: user2.id, community_id: community.id})
      assert {:error, %Ecto.Changeset{}} = CommunityInvitations.update_community_invitation(community_invitation, @invalid_attrs)
      assert community_invitation == CommunityInvitations.get_community_invitation!(community_invitation.id)
    end

    test "delete_community_invitation/1 deletes the community_invitation", %{user: user, user2: user2, community: community} do
      community_invitation = community_invitation_fixture(%{inviter_id: user.id, invited_id: user2.id, community_id: community.id})
      assert {:ok, %CommunityInvitation{}} = CommunityInvitations.delete_community_invitation(community_invitation)
      assert_raise Ecto.NoResultsError, fn -> CommunityInvitations.get_community_invitation!(community_invitation.id) end
    end

    test "change_community_invitation/1 returns a community_invitation changeset", %{user: user, user2: user2, community: community} do
      community_invitation = community_invitation_fixture(%{inviter_id: user.id, invited_id: user2.id, community_id: community.id})
      assert %Ecto.Changeset{} = CommunityInvitations.change_community_invitation(community_invitation)
    end
  end
end
