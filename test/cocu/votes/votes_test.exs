defmodule Cocu.VotesTest do
  use Cocu.DataCase

  alias Cocu.Votes

  describe "vote" do
    alias Cocu.Votes.Vote
    alias Cocu.Users
    alias Cocu.Users.User
    alias Cocu.Projects
    alias Cocu.Projects.Project
    alias Cocu.Categories
    alias Cocu.Categories.Category
    alias Cocu.Communities


    @project_attrs %{benefits: "some benefits", current_fund: 120.5, fund_asked: 120.5, fund_limit_date: ~D[2010-04-17], karma: 42, planning: "some planning", state: "funding", vision: "some vision", vision_name: "some vision_name", website: "some website", location: "Porto", impact: "international"}
    @user_attrs %{date_of_birth: ~D[2010-04-17], email: "some email", name: "some name", password: "some password", picture_path: "some picture_path", privileges_level: "user", username: "some username"}
    @category_attrs %{name: "some category"}
    @valid_attrs %{positive: true}
    @update_attrs %{positive: false}
    @invalid_attrs %{positive: nil}

    setup do
      assert {:ok, %Category{} = category} = Categories.create_category(@category_attrs)
      assert {:ok, %User{} = user} = Users.create_user(@user_attrs)
      assert {:ok, community} = Communities.create_community(%{founder_id: user.id, name: "test", description: "test"})
      assert {:ok, %Project{} = project} = Projects.create_project(
        Map.merge(@project_attrs, %{founder_id: user.id, category_id: category.id, community_id: community.id})
      )

      {:ok, %{user: user, project: project}}
    end

    def vote_fixture(%{user_id: user_id, project_id: project_id}) do
      {:ok, vote} = Votes.create_vote(Map.merge(@valid_attrs , %{user_id: user_id, project_id: project_id}))
      vote
    end

    test "list_vote/0 returns all vote", %{user: user, project: project} do
      vote_list = Votes.list_vote()
      vote = vote_fixture(%{user_id: user.id, project_id: project.id})
      vote_list = vote_list ++ [vote]
      assert (Votes.list_vote() -- vote_list) == []
    end

    test "get_vote!/1 returns the vote with given id", %{user: user, project: project} do
      vote = vote_fixture(%{user_id: user.id, project_id: project.id})
      assert Votes.get_vote!(vote.id) == vote
    end

    test "create_vote/1 with valid data creates a vote", %{user: user, project: project} do
      assert {:ok, %Vote{} = vote} = Votes.create_vote(
               %{positive: @valid_attrs.positive, user_id: user.id, project_id: project.id}
             )
      assert vote.positive == true
    end

    test "create_vote/1 with invalid data returns error changeset", %{user: user, project: project} do
      assert {:error, %Ecto.Changeset{}} = Votes.create_vote(
               %{positive: @invalid_attrs.positive, user_id: user.id, project_id: project.id}
             )
    end

    test "update_vote/2 with valid data updates the vote", %{user: user, project: project} do
      vote = vote_fixture(%{user_id: user.id, project_id: project.id})
      assert {:ok, vote} = Votes.update_vote(
               vote,
               %{positive: @update_attrs.positive, user_id: user.id, project_id: project.id}
             )
      assert %Vote{} = vote
      assert vote.positive == false
    end

    test "update_vote/2 with invalid data returns error changeset", %{user: user, project: project} do
      vote = vote_fixture(%{user_id: user.id, project_id: project.id})
      assert {:error, %Ecto.Changeset{}} = Votes.update_vote(
               vote,
               %{positive: @invalid_attrs.positive, user_id: user.id, project_id: project.id}
             )
      assert vote == Votes.get_vote!(vote.id)
    end

    test "delete_vote/1 deletes the vote", %{user: user, project: project} do
      vote = vote_fixture(%{user_id: user.id, project_id: project.id})
      assert {:ok, %Vote{}} = Votes.delete_vote(vote)
      assert_raise Ecto.NoResultsError, fn -> Votes.get_vote!(vote.id) end
    end

    test "change_vote/1 returns a vote changeset", %{user: user, project: project} do
      vote = vote_fixture(%{user_id: user.id, project_id: project.id})
      assert %Ecto.Changeset{} = Votes.change_vote(vote)
    end
  end
end
