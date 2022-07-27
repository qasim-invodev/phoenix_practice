defmodule Blogs.Content.Post do
  use Ecto.Schema
  import Ecto.Changeset
  alias Blogs.Content.Comment

  schema "posts" do
    field :body, :string
    field :title, :string
    field :views, :integer
    belongs_to :user, Blogs.Accounts.User
    has_many :comments, Comment

    timestamps()
  end

  @doc false
  def changeset(post, attrs) do
    post
    |> cast(attrs, [:user_id,:title, :body, :views])
    |> validate_required([:user_id,:title, :body])
  end
end
