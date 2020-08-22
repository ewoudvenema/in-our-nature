defmodule Cocu.NotificationDonations do
  @moduledoc """
  The NotificationDonations context.
  """

  import Ecto.Query, warn: false
  alias Cocu.Repo

  alias Cocu.NotificationDonations.NotificationDonation

  @doc """
  Returns the list of notification_donation.

  ## Examples

      iex> list_notification_donation()
      [%NotificationDonation{}, ...]

  """
  def list_notification_donation do
    Repo.all(NotificationDonation)
  end

  @doc """
  Gets a single notification_donation.

  Raises `Ecto.NoResultsError` if the Notification donation does not exist.

  ## Examples

      iex> get_notification_donation!(123)
      %NotificationDonation{}

      iex> get_notification_donation!(456)
      ** (Ecto.NoResultsError)

  """
  def get_notification_donation!(id), do: Repo.get!(NotificationDonation, id)

  @doc """
  Creates a notification_donation.

  ## Examples

      iex> create_notification_donation(%{field: value})
      {:ok, %NotificationDonation{}}

      iex> create_notification_donation(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_notification_donation(attrs \\ %{}) do
    %NotificationDonation{}
    |> NotificationDonation.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a notification_donation.

  ## Examples

      iex> update_notification_donation(notification_donation, %{field: new_value})
      {:ok, %NotificationDonation{}}

      iex> update_notification_donation(notification_donation, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_notification_donation(%NotificationDonation{} = notification_donation, attrs) do
    notification_donation
    |> NotificationDonation.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a NotificationDonation.

  ## Examples

      iex> delete_notification_donation(notification_donation)
      {:ok, %NotificationDonation{}}

      iex> delete_notification_donation(notification_donation)
      {:error, %Ecto.Changeset{}}

  """
  def delete_notification_donation(%NotificationDonation{} = notification_donation) do
    Repo.delete(notification_donation)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking notification_donation changes.

  ## Examples

      iex> change_notification_donation(notification_donation)
      %Ecto.Changeset{source: %NotificationDonation{}}

  """
  def change_notification_donation(%NotificationDonation{} = notification_donation) do
    NotificationDonation.changeset(notification_donation, %{})
  end
end
