defmodule Cocu.DonationsTest do
  use Cocu.DataCase

  alias Cocu.Donations
  alias Cocu.Users
  alias Cocu.Users.User
  alias Cocu.Projects
  alias Cocu.Projects.Project
  alias Cocu.Categories
  alias Cocu.Categories.Category
  alias Cocu.Communities

  describe "donation" do
    alias Cocu.Donations.Donation

    @valid_attrs %{value: 120.5}
    @update_attrs %{value: 456.7}
    @invalid_attrs %{value: nil, user_id: nil, project_id: nil}
    @category_attrs %{name: "some name"}
    @project_attrs %{benefits: "some benefits", current_fund: 120.5, fund_asked: 120.5, fund_limit_date: ~D[2010-04-17], karma: 42, planning: "some planning", state: "funding", vision: "some vision", vision_name: "some vision_name", website: "some website", location: "Porto", impact: "international"}
    @user_attrs %{date_of_birth: ~D[2010-04-17], email: "some email", name: "some name", password: "some password", picture_path: "some picture_path", privileges_level: "user", username: "some username"}
    
    setup do
      assert {:ok, %Category{} = category} = Categories.create_category(@category_attrs)
      assert {:ok, %User{} = user} = Users.create_user(@user_attrs)
      {:ok, community} = Communities.create_community(%{founder_id: user.id, name: "test", description: "test"})                      
      assert {:ok, %Project{} = project} = Projects.create_project(Map.merge(@project_attrs, %{category_id: category.id, founder_id: user.id, community_id: community.id}))
      
      {:ok, %{user: user, project: project}}      
    end

    def donation_fixture(attrs \\ %{}) do
      {:ok, donation} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Donations.create_donation()

      donation
    end

    test "list_donation/0 returns all donation", %{user: user, project: project} do
      donations = Donations.list_donation()
      donation = donation_fixture(%{value: @valid_attrs.value, user_id: user.id, project_id: project.id})
      donations = donations ++ [donation]
      assert Donations.list_donation() == donations
    end

    test "get_donation!/1 returns the donation with given id", %{user: user, project: project} do
      donation = donation_fixture(%{value: @valid_attrs.value, user_id: user.id, project_id: project.id})
      assert Donations.get_donation!(donation.id) == donation
    end

    test "create_donation/1 with valid data creates a donation", %{user: user, project: project} do
      assert {:ok, %Donation{} = donation} = Donations.create_donation(%{value: @valid_attrs.value, user_id: user.id, project_id: project.id})
      assert donation.value == 120.5
    end

    test "create_donation/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Donations.create_donation(@invalid_attrs)
    end

    test "update_donation/2 with valid data updates the donation", %{user: user, project: project} do
      donation = donation_fixture(%{value: @valid_attrs.value, user_id: user.id, project_id: project.id})
      assert {:ok, donation} = Donations.update_donation(donation, %{value: @update_attrs.value, user_id: user.id, project_id: project.id})
      assert %Donation{} = donation
      assert donation.value == 456.7
    end

    test "update_donation/2 with invalid data returns error changeset", %{user: user, project: project} do
      donation = donation_fixture(%{value: @valid_attrs.value, user_id: user.id, project_id: project.id})
      assert {:error, %Ecto.Changeset{}} = Donations.update_donation(donation, @invalid_attrs)
      assert donation == Donations.get_donation!(donation.id)
    end

    test "delete_donation/1 deletes the donation", %{user: user, project: project} do
      donation = donation_fixture(%{value: @valid_attrs.value, user_id: user.id, project_id: project.id})
      assert {:ok, %Donation{}} = Donations.delete_donation(donation)
      assert_raise Ecto.NoResultsError, fn -> Donations.get_donation!(donation.id) end
    end

    test "change_donation/1 returns a donation changeset", %{user: user, project: project} do
      donation = donation_fixture(%{value: @valid_attrs.value, user_id: user.id, project_id: project.id})
      assert %Ecto.Changeset{} = Donations.change_donation(donation)
    end
  end
end
