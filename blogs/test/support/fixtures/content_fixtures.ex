defmodule Blogs.ContentFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Blogs.Content` context.
  """

  @doc """
  Generate a post.
  """
  def post_fixture(attrs \\ %{}) do
    {:ok, post} =
      attrs
      |> Enum.into(%{
        body: "some body",
        title: "some title",
        views: 42
      })
      |> Blogs.Content.create_post()

    post
  end

  @doc """
  Generate a comment.
  """
  def comment_fixture(attrs \\ %{}) do
    {:ok, comment} =
      attrs
      |> Enum.into(%{
        body: "some body"
      })
      |> Blogs.Content.create_comment()

    comment
  end
end
