defmodule BlogsWeb.CommentController do
  use BlogsWeb, :controller

  alias Blogs.Content

  plug :scrub_params, "comment" when action in [:create, :update]
  # Comment CRUD Functions

  def create(conn, %{"post_id" => post_id, "comment" => comment_params}) do
    # define the post we are nested within
    post = Content.get_post!(post_id)
    user_id = conn.assigns.current_user.id
    changeset = Ecto.build_assoc(post, :comments, user_id: user_id)
    # create our new comment and handle (success or failure)
    case Content.create_comment(changeset, comment_params) do
      {:ok, _comment} ->
        conn
        |> put_flash(:info, "Comment created")
        |> redirect(to: Routes.post_path(conn, :show, post))

      # TODO: return to form and show errors
      {:error, _changeset} ->
        conn
        |> put_flash(:error, "Comment creation failed")
        |> redirect(to: Routes.post_path(conn, :show, post))
    end
  end

  def delete(conn, %{"id" => id, "post_id" => post_id}) do
    comment = Content.get_comment!(id)
     # Delete comment and Route to post
    {:ok, _comment} = Content.delete_comment(comment)

    conn
    |> put_flash(:info, "Deleted comment!")
    |> redirect(to: Routes.post_path(conn, :show, post_id))
  end


end
