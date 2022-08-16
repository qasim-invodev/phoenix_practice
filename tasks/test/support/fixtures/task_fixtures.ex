defmodule Tasks.TaskFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Tasks.Task` context.
  """

  @doc """
  Generate a todo_list.
  """
  def todo_list_fixture(attrs \\ %{}) do
    {:ok, todo_list} =
      attrs
      |> Enum.into(%{
        title: "some title"
      })
      |> Tasks.Task.create_todo_list()

    todo_list
  end
end
