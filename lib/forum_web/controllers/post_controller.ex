defmodule ForumWeb.PostController do
  use ForumWeb, :controller

  alias Forum.Posts
  alias Forum.Posts.Post

  action_fallback ForumWeb.FallbackController

  def index(conn, _params) do
    posts = Posts.list_posts()
    render(conn, :index, posts: posts)
  end

  def create(conn, %{"post" => post_params}) do
    result = Posts.create_post(post_params)
    IO.inspect(result, label: "db result")

    with {:ok, %Post{} = post} <- result do
      conn
      |> put_status(:created)
      |> put_resp_header("location", ~p"/api/posts/#{post}")
      |> render(:show, post: post)
    end
  end

  def show(conn, %{"id" => id}) do
    post = Posts.get_post!(id)
    render(conn, :show, post: post)
  end

  def update(conn, %{"id" => id, "post" => post_params}) do
    post = Posts.get_post!(id)

    case conn.method do
      "PUT" ->
        case Posts.replace_post(post, post_params) do
          {:ok, post} ->
            render(conn, :show, post: post)

          {:error, changeset} ->
            conn
            |> put_status(:unprocessable_entity)
            |> put_view(json: ForumWeb.ChangesetJSON)
            |> render(:error, changeset: changeset)
        end

      "PATCH" ->
        case Posts.update_post(post, post_params) do
          {:ok, post} ->
            render(conn, :show, post: post)

          {:error, changeset} ->
            conn
            |> put_status(:unprocessable_entity)
            |> put_view(json: ForumWeb.ChangesetJSON)
            |> render(:error, changeset: changeset)
        end
    end

    # with {:ok, %Post{} = post} <- Posts.update_post(post, post_params) do
    #   render(conn, :show, post: post)
    # end
  end

  def delete(conn, %{"id" => id}) do
    post = Posts.get_post!(id)

    with {:ok, %Post{}} <- Posts.delete_post(post) do
      send_resp(conn, :no_content, "")
    end
  end
end
