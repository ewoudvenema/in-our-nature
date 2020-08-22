defmodule Cocu.NotificationDonationsTest do
  use Cocu.DataCase

  alias Cocu.NotificationDonations
  alias Cocu.Donations
  alias Cocu.Donations.Donation
  alias Cocu.Users
  alias Cocu.Users.User
  alias Cocu.Projects
  alias Cocu.Projects.Project
  alias Cocu.Notifications
  alias Cocu.Notifications.Notification
  alias Cocu.Categories
  alias Cocu.Categories.Category
  alias Cocu.Communities
  alias Cocu.Communities.Community
  describe "notification_donation" do
    alias Cocu.NotificationDonations.NotificationDonation

    @valid_attrs %{}
    @update_attrs %{}
    @invalid_attrs %{notification_id: nil, donation_id: nil}
    @donation_attrs %{value: 120.5}
    @category_attrs %{name: "some category"}
    @project_attrs %{
      benefits: "some benefits",
      current_fund: 120.5,
      fund_asked: 120.5,
      fund_limit_date: ~D[2010-04-17],
      karma: 42,
      planning: "some planning",
      state: "funding",
      vision: "some vision",
      vision_name: "some vision_name",
      website: "some website",
      location: "Porto",
      impact: "global"
    }
    @user_attrs %{
      date_of_birth: ~D[2010-04-17],
      email: "some email",
      name: "some name",
      password: "some password",
      picture_path: "some picture_path",
      privileges_level: "user",
      username: "some username"
    }
    @notification_attrs %{seen: false}

    setup do
      assert {:ok, %User{} = user} = Users.create_user(@user_attrs)
      assert {:ok, %Category{} = category} = Categories.create_category(@category_attrs)
      assert {:ok, %Community{} = community} = Communities.create_community(%{founder_id: user.id, name: "test", description: "test"})
      assert {:ok, %Project{} = project} = Projects.create_project(
               Map.merge(@project_attrs, %{founder_id: user.id, category_id: category.id, community_id: community.id})
             )
      assert {:ok, %Donation{} = donation} = Donations.create_donation(
               %{value: @donation_attrs.value, user_id: user.id, project_id: project.id}
             )
      assert {:ok, %Notification{} = notification} = Notifications.create_notification(@notification_attrs)

      {:ok, %{notification: notification, donation: donation}}
    end

    def notification_donation_fixture(attrs \\ %{}) do
      {:ok, notification_donation} =
        attrs
        |> Enum.into(@valid_attrs)
        |> NotificationDonations.create_notification_donation()

      notification_donation
    end

    test "list_notification_donation/0 returns all notification_donation",
         %{notification: notification, donation: donation} do
      notifications = NotificationDonations.list_notification_donation()
      notification_donation = notification_donation_fixture(
        %{notification_id: notification.id, donation_id: donation.id}
      )
      notifications = notifications ++ [notification_donation]
      assert NotificationDonations.list_notification_donation() == notifications
    end

    test "get_notification_donation!/1 returns the notification_donation with given id",
         %{notification: notification, donation: donation} do
      notification_donation = notification_donation_fixture(
        %{notification_id: notification.id, donation_id: donation.id}
      )
      assert NotificationDonations.get_notification_donation!(notification_donation.id) == notification_donation
    end

    test "create_notification_donation/1 with valid data creates a notification_donation",
         %{notification: notification, donation: donation} do
      assert {:ok, %NotificationDonation{} = notification_donation } = NotificationDonations.create_notification_donation(
               %{notification_id: notification.id, donation_id: donation.id}
             )
      assert notification_donation.donation_id == donation.id
      assert notification_donation.notification_id == notification.id
    end

    test "create_notification_donation/1 with invalid data returns error changeset", _ do
      assert {:error, %Ecto.Changeset{}} = NotificationDonations.create_notification_donation(@invalid_attrs)
    end

    test "update_notification_donation/2 with valid data updates the notification_donation",
         %{notification: notification, donation: donation} do
      notification_donation = notification_donation_fixture(
        %{notification_id: notification.id, donation_id: donation.id}
      )
      assert {:ok, notification_donation} = NotificationDonations.update_notification_donation(
               notification_donation,
               @update_attrs
             )
      assert %NotificationDonation{} = notification_donation
    end

    test "update_notification_donation/2 with invalid data returns error changeset",
         %{notification: notification, donation: donation} do
      notification_donation = notification_donation_fixture(
        %{notification_id: notification.id, donation_id: donation.id}
      )
      assert {:error, %Ecto.Changeset{}} = NotificationDonations.update_notification_donation(
               notification_donation,
               @invalid_attrs
             )
      assert notification_donation == NotificationDonations.get_notification_donation!(notification_donation.id)
    end

    test "delete_notification_donation/1 deletes the notification_donation",
         %{notification: notification, donation: donation} do
      notification_donation = notification_donation_fixture(
        %{notification_id: notification.id, donation_id: donation.id}
      )
      assert {:ok, %NotificationDonation{}} = NotificationDonations.delete_notification_donation(notification_donation)
      assert_raise Ecto.NoResultsError,
                   fn -> NotificationDonations.get_notification_donation!(notification_donation.id) end
    end

    test "change_notification_donation/1 returns a notification_donation changeset",
         %{notification: notification, donation: donation} do
      notification_donation = notification_donation_fixture(
        %{notification_id: notification.id, donation_id: donation.id}
      )
      assert %Ecto.Changeset{} = NotificationDonations.change_notification_donation(notification_donation)
    end
  end
end
