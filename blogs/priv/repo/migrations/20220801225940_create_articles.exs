defmodule Blogs.Repo.Migrations.CreateArticles do
  use Ecto.Migration

  def change do
    create table(:articles) do
      add :title, :string, null: false
      add :body, :string, null: false

      timestamps()
    end
  end
end
