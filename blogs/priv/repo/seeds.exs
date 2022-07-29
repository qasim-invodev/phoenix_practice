# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Blogs.Repo.insert!(%Blogs.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.


alias Blogs.Content.Comment

Repo.insert!(%Comment{user_id: dog.id, post_id: post1.id, message: "woof" })

# this also checks the relationships
post2
|> Ecto.build_assoc(:comments)
|> Comment.changeset(%{user_id: dog.id, post_id: post2.id, message: "BARK" })
|> Repo.insert!()
