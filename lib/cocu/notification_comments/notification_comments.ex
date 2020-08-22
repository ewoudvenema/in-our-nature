defmodule Cocu.NotificationComments do
  @moduledoc """
  The NotificationComments context.
  """

  import Ecto.Query, warn: false
  alias Cocu.Repo

  alias Cocu.NotificationComments.NotificationComment

  @doc """
  Returns the list of notification_comment.

  ## Examples

      iex> list_notification_comment()
      [%NotificationComment{}, ...]

  """
  def list_notification_comment do
    Repo.all(NotificationComment)
  end

  @doc """
  Gets a single notification_comment.

  Raises `Ecto.NoResultsError` if the Notification comment does not exist.

  ## Examples

      iex> get_notification_comment!(123)
      %NotificationComment{}

      iex> get_notification_comment!(456)
      ** (Ecto.NoResultsError)

  """
  def get_notification_comment!(id), do: Repo.get!(NotificationComment, id)

  @doc """
  Creates a notification_comment.

  ## Examples

      iex> create_notification_comment(%{field: value})
      {:ok, %NotificationComment{}}

      iex> create_notification_comment(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_notification_comment(attrs \\ %{}) do
    %NotificationComment{}
    |> NotificationComment.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a notification_comment.

  ## Examples

      iex> update_notification_comment(notification_comment, %{field: new_value})
      {:ok, %NotificationComment{}}

      iex> update_notification_comment(notification_comment, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_notification_comment(%NotificationComment{} = notification_comment, attrs) do
    notification_comment
    |> NotificationComment.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a NotificationComment.

  ## Examples

      iex> delete_notification_comment(notification_comment)
      {:ok, %NotificationComment{}}

      iex> delete_notification_comment(notification_comment)
      {:error, %Ecto.Changeset{}}

  """
  def delete_notification_comment(%NotificationComment{} = notification_comment) do
    Repo.delete(notification_comment)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking notification_comment changes.

  ## Examples

      iex> change_notification_comment(notification_comment)
      %Ecto.Changeset{source: %NotificationComment{}}

  """
  def change_notification_comment(%NotificationComment{} = notification_comment) do
    NotificationComment.changeset(notification_comment, %{})
  end
end
