defmodule Tasks.TaskTest do
  use Tasks.DataCase

  alias Tasks.Task

  describe "todo_lists" do
    alias Tasks.Task.TodoList

    import Tasks.TaskFixtures

    @invalid_attrs %{title: nil}

    test "list_todo_lists/0 returns all todo_lists" do
      todo_list = todo_list_fixture()
      assert Task.list_todo_lists() == [todo_list]
    end

    test "get_todo_list!/1 returns the todo_list with given id" do
      todo_list = todo_list_fixture()
      assert Task.get_todo_list!(todo_list.id) == todo_list
    end

    test "create_todo_list/1 with valid data creates a todo_list" do
      valid_attrs = %{title: "some title"}

      assert {:ok, %TodoList{} = todo_list} = Task.create_todo_list(valid_attrs)
      assert todo_list.title == "some title"
    end

    test "create_todo_list/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Task.create_todo_list(@invalid_attrs)
    end

    test "update_todo_list/2 with valid data updates the todo_list" do
      todo_list = todo_list_fixture()
      update_attrs = %{title: "some updated title"}

      assert {:ok, %TodoList{} = todo_list} = Task.update_todo_list(todo_list, update_attrs)
      assert todo_list.title == "some updated title"
    end

    test "update_todo_list/2 with invalid data returns error changeset" do
      todo_list = todo_list_fixture()
      assert {:error, %Ecto.Changeset{}} = Task.update_todo_list(todo_list, @invalid_attrs)
      assert todo_list == Task.get_todo_list!(todo_list.id)
    end

    test "delete_todo_list/1 deletes the todo_list" do
      todo_list = todo_list_fixture()
      assert {:ok, %TodoList{}} = Task.delete_todo_list(todo_list)
      assert_raise Ecto.NoResultsError, fn -> Task.get_todo_list!(todo_list.id) end
    end

    test "change_todo_list/1 returns a todo_list changeset" do
      todo_list = todo_list_fixture()
      assert %Ecto.Changeset{} = Task.change_todo_list(todo_list)
    end
  end
end
