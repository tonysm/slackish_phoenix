defmodule SlackishPhoenixWeb.CompanyController do
  use SlackishPhoenixWeb, :controller

  plug SlackishPhoenixWeb.Plugs.RequireAuth

  def new(conn, _params) do
    text conn, "Show create company form"
  end
end
