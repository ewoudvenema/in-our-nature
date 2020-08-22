defmodule Cocu.PostReplies do
  @moduledoc """
  The PostReplies context.
  """

  import Ecto.Query, warn: false
  alias Cocu.Repo

  alias Cocu.PostReplies.PostReply

  @doc """
  Returns the list of post_reply.

  ## Examples

      iex> list_post_reply()
      [%PostReply{}, ...]

  """
  def list_post_reply do
    Repo.all(PostReply)
  end

  @doc """
  Gets a single post_reply.

  Raises `Ecto.NoResultsError` if the Post reply does not exist.

  ## Examples

      iex> get_post_reply!(123)
      %PostReply{}

      iex> get_post_reply!(456)
      ** (Ecto.NoResultsError)

  """
  def get_post_reply!(id), do: Repo.get!(PostReply, id)

  @doc """
  Creates a post_reply.

  ## Examples

      iex> create_post_reply(%{field: value})
      {:ok, %PostReply{}}

      iex> create_post_reply(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_post_reply(attrs \\ %{}) do
    %PostReply{}
    |> PostReply.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a post_reply.

  ## Examples

      iex> update_post_reply(post_reply, %{field: new_value})
      {:ok, %PostReply{}}

      iex> update_post_reply(post_reply, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_post_reply(%PostReply{} = post_reply, attrs) do
    post_reply
    |> PostReply.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a PostReply.

  ## Examples

      iex> delete_post_reply(post_reply)
      {:ok, %PostReply{}}

      iex> delete_post_reply(post_reply)
      {:error, %Ecto.Changeset{}}

  """
  def delete_post_reply(%PostReply{} = post_reply) do
    Repo.delete(post_reply)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking post_reply changes.

  ## Examples

      iex> change_post_reply(post_reply)
      %Ecto.Changeset{source: %PostReply{}}

  """
  def change_post_reply(%PostReply{} = post_reply) do
    PostReply.changeset(post_reply, %{})
  end
end
