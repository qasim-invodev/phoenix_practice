defmodule Blogs.ContentFixtures do
  alias Blogs.Content.Post
  alias Blogs.Accounts.User
  alias Blogs.Content.Comment
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Blogs.Content` context.
  """

  @doc """
  Generate a post.
  """
  def post_fixture(%User{} = user, attrs \\ %{}) do
    post = %Post{user_id: user.id}
    changeset = Enum.into(attrs, %{
      body: "some body",
      title: "some title",
      views: 42
    })
    {:ok, post} = Blogs.Content.create_post(post, changeset)
    post
  end

  @doc """
  Generate a comment.
  """
  def comment_fixture(%Post{} = post,%User{} = user, attrs \\ %{}) do
    comment = %Comment{post_id: post.id, user_id: user.id}
    changeset = attrs
    |> Enum.into(%{
      body: "some body"
    })

    {:ok, comment} = Blogs.Content.create_comment(comment, changeset)

    comment
  end
end
