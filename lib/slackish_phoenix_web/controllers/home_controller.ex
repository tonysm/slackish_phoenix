defmodule SlackishPhoenixWeb.HomeController do
  use SlackishPhoenixWeb, :controller

  def index(conn, _params) do
    text conn, "Works"
  end
end
