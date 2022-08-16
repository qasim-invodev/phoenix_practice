defmodule Tasks.Task.TodoList do
  use Ecto.Schema
  import Ecto.Changeset

  schema "todo_lists" do
    field :title, :string
    has_many :todo_items, Tasks.Task.TodoItem

    timestamps()
  end

  @doc false
  def changeset(todo_list, attrs) do
    todo_list
    |> cast(attrs, [:title])
    |> cast_assoc(:todo_items, required: true, with: &Tasks.Task.TodoItem.changeset/2)
  end
end
