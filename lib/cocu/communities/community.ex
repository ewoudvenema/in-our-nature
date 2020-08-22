defmodule Cocu.Communities.Community do
  use Ecto.Schema
  import Ecto.Changeset
  alias Cocu.Communities.Community
  alias Cocu.CommunityInvitations
  alias Cocu.CommunityInvitations.CommunityInvitation
  alias Cocu.CommunityPosts.CommunityPost
  alias Cocu.CommunityProjects.CommunityProject
  alias Cocu.CommunityUsers.CommunityUser


  schema "community" do
    field :founder_id, :id
    field :description, :string
    field :is_group, :boolean
    field :name, :string
    field :picture_path, :string

    has_many :community_invitations, CommunityInvitation
    has_many :community_post, CommunityPost
    has_many :community_project, CommunityProject
    has_many :community_user, CommunityUser
    timestamps()
  end

  @doc false
  def changeset(%Community{} = community, attrs) do
    community
    |> cast(attrs, [:founder_id, :name, :is_group, :description, :picture_path])
    |> validate_required([:founder_id, :name, :description])
    |> unique_constraint(:name)
    |> foreign_key_constraint(:founder_id)
  end
end
