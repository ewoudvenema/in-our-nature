defmodule Cocu.NotificationReplies do
  @moduledoc """
  The NotificationReplies context.
  """

  import Ecto.Query, warn: false
  alias Cocu.Repo

  alias Cocu.NotificationReplies.NotificationReply

  @doc """
  Returns the list of notification_reply.

  ## Examples

      iex> list_notification_reply()
      [%NotificationReply{}, ...]

  """
  def list_notification_reply do
    Repo.all(NotificationReply)
  end

  @doc """
  Gets a single notification_reply.

  Raises `Ecto.NoResultsError` if the Notification reply does not exist.

  ## Examples

      iex> get_notification_reply!(123)
      %NotificationReply{}

      iex> get_notification_reply!(456)
      ** (Ecto.NoResultsError)

  """
  def get_notification_reply!(id), do: Repo.get!(NotificationReply, id)

  @doc """
  Creates a notification_reply.

  ## Examples

      iex> create_notification_reply(%{field: value})
      {:ok, %NotificationReply{}}

      iex> create_notification_reply(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_notification_reply(attrs \\ %{}) do
    %NotificationReply{}
    |> NotificationReply.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a notification_reply.

  ## Examples

      iex> update_notification_reply(notification_reply, %{field: new_value})
      {:ok, %NotificationReply{}}

      iex> update_notification_reply(notification_reply, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_notification_reply(%NotificationReply{} = notification_reply, attrs) do
    notification_reply
    |> NotificationReply.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a NotificationReply.

  ## Examples

      iex> delete_notification_reply(notification_reply)
      {:ok, %NotificationReply{}}

      iex> delete_notification_reply(notification_reply)
      {:error, %Ecto.Changeset{}}

  """
  def delete_notification_reply(%NotificationReply{} = notification_reply) do
    Repo.delete(notification_reply)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking notification_reply changes.

  ## Examples

      iex> change_notification_reply(notification_reply)
      %Ecto.Changeset{source: %NotificationReply{}}

  """
  def change_notification_reply(%NotificationReply{} = notification_reply) do
    NotificationReply.changeset(notification_reply, %{})
  end
end
