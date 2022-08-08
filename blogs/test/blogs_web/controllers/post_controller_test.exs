defmodule BlogsWeb.PostControllerTest do
  use BlogsWeb.ConnCase

  import Blogs.ContentFixtures
  import Blogs.AccountsFixtures

  @create_attrs %{body: "some body", title: "some title", views: 42}
  @update_attrs %{body: "some updated body", title: "some updated title", views: 43}
  @invalid_attrs %{body: nil, title: nil, views: nil}

  @moduletag :post_controller

  setup %{conn: conn} do
    user = user_fixture()
    conn = log_in_user(conn, user)
    conn = assign(conn, :current_user, user)
    %{user: user, conn: conn}
  end

  describe "index" do
    test "lists all posts", %{conn: conn} do
      conn = get(conn, Routes.post_path(conn, :index))
      assert html_response(conn, 200) =~ "All Posts"
    end
  end

  describe "logged in index" do
    test "lists my posts", %{conn: conn} do
      conn = get(conn, Routes.post_path(conn, :logged_in_index))
      assert html_response(conn, 200) =~ "My Posts"
    end
  end

  describe "new post" do
    test "renders form", %{conn: conn} do
      conn = get(conn, Routes.post_path(conn, :new))
      assert html_response(conn, 200) =~ "New Post"
    end
  end

  describe "create post" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post(conn, Routes.post_path(conn, :create), post: @create_attrs)
      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == Routes.post_path(conn, :show, id)

      conn = get(conn, Routes.post_path(conn, :show, id))
      assert html_response(conn, 200) =~ "Show Post"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.post_path(conn, :create), post: @invalid_attrs)
      assert html_response(conn, 200) =~ "New Post"
    end
  end

  describe "edit post" do
    setup [:create_post]

    test "renders form for editing chosen post", %{conn: conn, post: post} do
      assert conn.assigns.current_user.id == post.user_id
      conn = get(conn, Routes.post_path(conn, :edit, post))
      assert html_response(conn, 200) =~ "Edit Post"
    end
  end

  describe "update post" do
    setup [:create_post]

    test "redirects when data is valid", %{conn: conn, post: post} do
      assert conn.assigns.current_user.id == post.user_id
      conn = put(conn, Routes.post_path(conn, :update, post), post: @update_attrs)
      assert redirected_to(conn) == Routes.post_path(conn, :show, post)

      conn = get(conn, Routes.post_path(conn, :show, post))
      assert html_response(conn, 200) =~ "some updated body"
    end

    test "renders errors when data is invalid", %{conn: conn, post: post} do
      assert conn.assigns.current_user.id == post.user_id
      conn = put(conn, Routes.post_path(conn, :update, post), post: @invalid_attrs)
      assert html_response(conn, 200) =~ "Edit Post"
    end
  end

  describe "delete post" do
    setup [:create_post]

    test "deletes chosen post", %{conn: conn, post: post} do
      assert conn.assigns.current_user.id == post.user_id
      conn = delete(conn, Routes.post_path(conn, :delete, post))
      assert redirected_to(conn) == Routes.post_path(conn, :index)

      assert_error_sent 404, fn ->
        get(conn, Routes.post_path(conn, :show, post))
      end
    end
  end

  defp create_post(%{user: user}) do
    post = post_fixture(user)
    %{post: post}
  end

  # defp create_user(_) do
  #   {:ok, email: email, password: password} =user = user_fixture()
  #   %{user: user, }
  # end

  # defp login_as_registered_user(%{conn: conn}) do
  #   conn = post(conn, session_path(conn, :create), %{session: @user_attrs})
  #   {:ok, conn: conn}
  # end
end
