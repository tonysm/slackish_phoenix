defmodule SlackishPhoenixWeb.PageController do
  use SlackishPhoenixWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
