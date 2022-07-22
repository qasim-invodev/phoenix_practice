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
end
