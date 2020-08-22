defmodule Cocu.ReplyPostReplies do
  @moduledoc """
  The ReplyPostReplies context.
  """

  import Ecto.Query, warn: false
  alias Cocu.Repo

  alias Cocu.ReplyPostReplies.ReplyPostReply

  @doc """
  Returns the list of reply_post_reply.

  ## Examples

      iex> list_reply_post_reply()
      [%ReplyPostReply{}, ...]

  """
  def list_reply_post_reply do
    Repo.all(ReplyPostReply)
  end

  @doc """
  Gets a single reply_post_reply.

  Raises `Ecto.NoResultsError` if the Reply post reply does not exist.

  ## Examples

      iex> get_reply_post_reply!(123)
      %ReplyPostReply{}

      iex> get_reply_post_reply!(456)
      ** (Ecto.NoResultsError)

  """
  def get_reply_post_reply!(id), do: Repo.get!(ReplyPostReply, id)

  @doc """
  Creates a reply_post_reply.

  ## Examples

      iex> create_reply_post_reply(%{field: value})
      {:ok, %ReplyPostReply{}}

      iex> create_reply_post_reply(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_reply_post_reply(attrs \\ %{}) do
    %ReplyPostReply{}
    |> ReplyPostReply.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a reply_post_reply.

  ## Examples

      iex> update_reply_post_reply(reply_post_reply, %{field: new_value})
      {:ok, %ReplyPostReply{}}

      iex> update_reply_post_reply(reply_post_reply, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_reply_post_reply(%ReplyPostReply{} = reply_post_reply, attrs) do
    reply_post_reply
    |> ReplyPostReply.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a ReplyPostReply.

  ## Examples

      iex> delete_reply_post_reply(reply_post_reply)
      {:ok, %ReplyPostReply{}}

      iex> delete_reply_post_reply(reply_post_reply)
      {:error, %Ecto.Changeset{}}

  """
  def delete_reply_post_reply(%ReplyPostReply{} = reply_post_reply) do
    Repo.delete(reply_post_reply)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking reply_post_reply changes.

  ## Examples

      iex> change_reply_post_reply(reply_post_reply)
      %Ecto.Changeset{source: %ReplyPostReply{}}

  """
  def change_reply_post_reply(%ReplyPostReply{} = reply_post_reply) do
    ReplyPostReply.changeset(reply_post_reply, %{})
  end
end
