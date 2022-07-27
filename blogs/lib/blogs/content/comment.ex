defmodule Blogs.Content.Comment do
  use Ecto.Schema
  import Ecto.Changeset
  alias Blogs.Content.Post
  alias Blogs.Accounts.User

  schema "comments" do
    field :body, :string
    belongs_to :post, Post
    belongs_to :user, User
    timestamps()
  end

  @doc false
  def changeset(comment, attrs) do
    comment
    |> cast(attrs, [:body])
    |> validate_required([:body, :user_id, :post_id])
  end
end
