defmodule Blogs.ContentTest do
  use Blogs.DataCase

  alias Blogs.Content
  alias Blogs.Content.Comment
  alias Blogs.Content.Post
  import Blogs.ContentFixtures
  import Blogs.AccountsFixtures

  @moduletag :content_test
  describe "posts" do
    setup do
      user = user_fixture()
      %{user: user}
    end
    @valid_attrs %{body: "some body", title: "some title", views: 42}
    @invalid_attrs %{body: nil, title: nil, views: nil}
    test "list_posts/0 returns all posts",%{user: user}  do
      post = post_fixture(user)
      assert Content.list_posts() == [post |> Repo.preload([:user])]
    end

    test "get_post!/1 returns the post with given id",%{user: user} do
      post = post_fixture(user)
      assert Content.get_post!(post.id) == post |> Repo.preload([:user, comments: [:user]])
    end
    test "create_post/1 with valid data creates a post", %{user: user} do
      assert {:ok, post} = Content.create_post(%Post{user_id: user.id}, @valid_attrs)
      assert post.body == "some body"
      assert post.title == "some title"
      assert post.views == 42
    end

    test "create_post/1 with invalid data returns error changeset", %{user: user} do
      assert {:error, %Ecto.Changeset{}} = Content.create_post(%Post{user_id: user.id}, @invalid_attrs)
    end

    test "update_post/2 with valid data updates the post",%{user: user} do
      post = post_fixture(user)
      update_attrs = %{body: "some updated body", title: "some updated title", views: 43}

      assert {:ok, post} = Content.update_post(post, update_attrs)
      assert post.body == "some updated body"
      assert post.title == "some updated title"
      assert post.views == 43
    end

    test "update_post/2 with invalid data returns error changeset",%{user: user} do
      post = post_fixture(user)
      assert {:error, %Ecto.Changeset{}} = Content.update_post(post, @invalid_attrs)
      assert post |> Repo.preload([:user, comments: [:user]]) == Content.get_post!(post.id)
    end

    test "delete_post/1 deletes the post",%{user: user} do
      post = post_fixture(user)
      assert {:ok, _post} = Content.delete_post(post)
      assert_raise Ecto.NoResultsError, fn -> Content.get_post!(post.id) end
    end

    test "change_post/1 returns a post changeset",%{user: user} do
      post = post_fixture(user)
      assert %Ecto.Changeset{} = Content.change_post(post)
    end
  end

  describe "comments" do
    setup do
      user = user_fixture()
      post = post_fixture(user)
      %{user: user, post: post}
    end

    @invalid_attrs %{body: nil, user_id: nil, post_id: nil}
    test "get_comment!/1 returns the comment with given id", %{user: user, post: post} do
      comment = comment_fixture(post, user)
      assert Content.get_comment!(comment.id) == comment
    end

    test "create_comment/1 with valid data creates a comment", %{user: user, post: post} do
      valid_attrs = %{body: "some body"}

      assert {:ok, comment} = Content.create_comment(%Comment{post_id: post.id, user_id: user.id}, valid_attrs)
      assert comment.body == "some body"
      assert comment.user_id == user.id
      assert comment.post_id == post.id
    end

    test "create_comment/1 with a different user creates a comment from user2 on post of user1", %{user: _user, post: post} do
      valid_attrs = %{body: "some body new"}
      user2 = user_fixture()
      assert {:ok, comment} = Content.create_comment(%Comment{post_id: post.id, user_id: user2.id}, valid_attrs)
      assert comment.body == "some body new"
      assert comment.user_id == user2.id
      assert comment.post_id == post.id
    end

    test "create_comment/1 with invalid data returns error changeset", %{user: user, post: post} do
      assert {:error, %Ecto.Changeset{}} = Content.create_comment(%Comment{post_id: post.id, user_id: user.id}, @invalid_attrs)
    end

    test "update_comment/2 with valid data updates the comment", %{user: user, post: post} do
      comment = comment_fixture(post, user)
      update_attrs = %{body: "some updated body"}

      assert {:ok, %Comment{} = comment} = Content.update_comment(comment, update_attrs)
      assert comment.body == "some updated body"
    end

    test "update_comment/2 with invalid data returns error changeset", %{user: user, post: post} do
      comment = comment_fixture(post, user)
      assert {:error, %Ecto.Changeset{}} = Content.update_comment(comment, @invalid_attrs)
      assert comment == Content.get_comment!(comment.id)
    end

    test "delete_comment/1 deletes the comment", %{user: user, post: post} do
      comment = comment_fixture(post, user)
      assert {:ok, %Comment{}} = Content.delete_comment(comment)
      assert_raise Ecto.NoResultsError, fn -> Content.get_comment!(comment.id) end
    end

    test "change_comment/1 returns a comment changeset", %{user: user, post: post} do
      comment = comment_fixture(post, user)
      assert %Ecto.Changeset{} = Content.change_comment(comment)
    end
  end
end
