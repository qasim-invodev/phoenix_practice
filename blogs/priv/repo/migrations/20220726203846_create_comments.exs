defmodule Blogs.Repo.Migrations.CreateComments do
  use Ecto.Migration

  def change do
    create table(:comments) do
      add :body, :string, null: false
      add :post_id, references(:posts, on_delete: :delete_all), null: false
      add :user_id, references(:users, on_delete: :delete_all), null: false
      timestamps()
    end

    create index(:comments, [:post_id])
    create index(:comments, [:user_id])
    create unique_index(:comments, [:post_id, :user_id, :id])
  end
end
