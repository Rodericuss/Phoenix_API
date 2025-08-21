defmodule ForumWeb.UserJSON do
  alias Hex.API.User
  alias Forum.Account.User
  alias Forum.Posts.Post

  @doc """
  Renders a list of users.
  """
  def index(%{users: users}) do
    %{data: for(user <- users, do: data(user))}
  end

  @doc """
  Renders a single user.
  """
  def show(%{user: user}) do
    %{data: data(user)}
  end

  defp data(%User{} = user) do
    %{
      id: user.id,
      name: user.name,
      email: user.email,
      posts:
        Enum.map(user.posts, fn post ->
          %{
            id: post.id,
            title: post.title,
            body: post.body
          }
        end)
      # posts: Enum.map(user.posts, &post_data/1)
      # posts: for(post <- user.posts, do: post_data(post))
    }
  end

  # defp post_data(%Post{} = post) do
  #   %{
  #     id: post.id,
  #     title: post.title,
  #     body: post.body
  #   }
  # end
end
