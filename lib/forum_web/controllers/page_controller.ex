defmodule ForumWeb.PageController do
  use ForumWeb, :controller

  def home(conn, _params) do
    render(conn, :home)
  end

  def users(conn, _params) do
    IO.puts("User function hit!")

    users = [
      %{name: "Cheila", id: 1, email: "rodrigo@gmail.com"},
      %{name: "Rodrigo", id: 2, email: "evdd@gmail.com"}
    ]

    # render(conn, :users, users: users, layout: false)
    json(conn, %{users: users})
  end
end
