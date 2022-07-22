defmodule Blogs.Content.Post do
  use Ecto.Schema
  import Ecto.Changeset

  schema "posts" do
    field :body, :string
    field :title, :string
    field :views, :integer
    belongs_to :user, Blog.Accounts.User

    timestamps()
  end

  @doc false
  def changeset(post, attrs) do
    post
    |> cast(attrs, [:user_id,:title, :body, :views])
    |> validate_required([:user_id,:title, :body, :views])
  end
end
