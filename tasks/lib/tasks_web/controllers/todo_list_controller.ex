defmodule TasksWeb.TodoListController do
  use TasksWeb, :controller

  alias Tasks.Task
  alias Tasks.Task.TodoList
  alias Tasks.Task.TodoItem

  def index(conn, _params) do
    todo_lists = Task.list_todo_lists()
    render(conn, "index.html", todo_lists: todo_lists)
  end

  def new(conn, _params) do
    changeset = Task.change_todo_list(%TodoList{todo_items: [%TodoItem{}, %TodoItem{}]})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"todo_list" => todo_list_params}) do
    case Task.create_todo_list(todo_list_params) do
      {:ok, todo_list} ->
        conn
        |> put_flash(:info, "Todo list created successfully.")
        |> redirect(to: Routes.todo_list_path(conn, :show, todo_list))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    todo_list = Task.get_todo_list!(id)
    render(conn, "show.html", todo_list: todo_list)
  end

  def edit(conn, %{"id" => id}) do
    todo_list = Task.get_todo_list!(id)
    changeset = Task.change_todo_list(todo_list)
    render(conn, "edit.html", todo_list: todo_list, changeset: changeset)
  end

  def update(conn, %{"id" => id, "todo_list" => todo_list_params}) do
    todo_list = Task.get_todo_list!(id)

    case Task.update_todo_list(todo_list, todo_list_params) do
      {:ok, todo_list} ->
        conn
        |> put_flash(:info, "Todo list updated successfully.")
        |> redirect(to: Routes.todo_list_path(conn, :show, todo_list))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", todo_list: todo_list, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    todo_list = Task.get_todo_list!(id)
    {:ok, _todo_list} = Task.delete_todo_list(todo_list)

    conn
    |> put_flash(:info, "Todo list deleted successfully.")
    |> redirect(to: Routes.todo_list_path(conn, :index))
  end
end
