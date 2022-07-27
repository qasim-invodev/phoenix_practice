defmodule BlogsWeb.PostController do
  use BlogsWeb, :controller

  alias Blogs.Content
  alias Blogs.Content.Post
  alias Blogs.Content.Comment

  def index(conn, _params) do
    posts = Content.list_posts()
    render(conn, "index.html", posts: posts)
  end

  def logged_in_index(conn,  _params) do
    id = conn.assigns.current_user.id
    posts = Content.list_posts_logged_in(id)
    render(conn, "index_logged_in.html", posts: posts)
  end

  def new(conn, _params) do
    changeset = Content.change_post(%Post{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"post" => post_params}) do
    current_user = conn.assigns.current_user
    changeset = Ecto.build_assoc(current_user, :posts, post_params)
    case Content.create_post(changeset,post_params) do
      {:ok, post} ->
        conn
        |> put_flash(:info, "Post created successfully.")
        |> redirect(to: Routes.post_path(conn, :show, post))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  #Updated Show Action
  def show(conn, %{"id" => id}) do
    post = Content.get_post!(id) |> Content.inc_page_views()
    users = Content.list_users()
    comment_changeset = Content.change_comment(%Comment{})
    render(conn, "show.html", post: post, comment_changeset: comment_changeset)
  end

  def edit(conn, %{"id" => id}) do
    post = Content.get_post!(id)
    changeset = Content.change_post(post)
    render(conn, "edit.html", post: post, changeset: changeset)
  end

  def update(conn, %{"id" => id, "post" => post_params}) do
    post = Content.get_post!(id)

    case Content.update_post(post, post_params) do
      {:ok, post} ->
        conn
        |> put_flash(:info, "Post updated successfully.")
        |> redirect(to: Routes.post_path(conn, :show, post))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", post: post, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    post = Content.get_post!(id)
    {:ok, _post} = Content.delete_post(post)

    conn
    |> put_flash(:info, "Post deleted successfully.")
    |> redirect(to: Routes.post_path(conn, :index))
  end


  #  # Comment CRUD Functions

  # def create_comment(conn, %{"post_id" => post_id, "comment" => comment_params}) do
  #   # define the post we are nested within
  #   post = Content.get_post!(post_id)
  #   user_id = conn.assigns.current_user.id
  #   changeset = Ecto.build_assoc(post, :comments, user_id: user_id)
  #   # create our new comment and handle (success or failure)
  #   case Content.create_comment(changeset, comment_params) do
  #     {:ok, _comment} ->
  #       conn
  #       |> put_flash(:info, "Comment created")
  #       |> redirect(to: Routes.post_path(conn, :show, post))

  #     # TODO: return to form and show errors
  #     {:error, _changeset} ->
  #       conn
  #       |> put_flash(:error, "Comment creation failed")
  #       |> redirect(to: Routes.post_path(conn, :show, post))
  #   end
  # end

  # def delete_comment(conn, %{"id" => id, "post_id" => post_id}) do
  #   comment = Content.get_comment!(id)
  #    # Delete comment and Route to post
  #   {:ok, _comment} = Content.delete_comment(comment)

  #   conn
  #   |> put_flash(:info, "Deleted comment!")
  #   |> redirect(to: Routes.post_path(conn, :show, post_id))
  # end

  # def update_comment(conn, %{"id" => id, "post_id" => post_id, "comment" => comment_params}) do
  #   # comment = Content.get_comment!(id)
  #   #  # Delete comment and Route to post
  #   # {:ok, _comment} = Content.delete_comment(comment)

  #   # conn
  #   # |> put_flash(:info, "Deleted comment!")
  #   # |> redirect(to: Routes.post_path(conn, :show, post_id))
  # end
end
