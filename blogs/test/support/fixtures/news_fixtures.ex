defmodule Blogs.NewsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Blogs.News` context.
  """

  @doc """
  Generate a article.
  """
  def article_fixture(attrs \\ %{}) do
    {:ok, article} =
      attrs
      |> Enum.into(%{
        body: "some body",
        title: "some title"
      })
      |> Blogs.News.create_article()

    article
  end
end
