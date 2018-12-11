defmodule SlackishPhoenixWeb.Router do
  use SlackishPhoenixWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug :detect_user_in_session
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", SlackishPhoenixWeb do
    pipe_through :browser

    get "/", PageController, :index
    get "/home", HomeController, :index
  end

  scope "/auth", SlackishPhoenixWeb do
    pipe_through :browser

    get "/:provider", AuthController, :request
    get "/:provider/callback", AuthController, :callback
  end

  # Other scopes may use custom stacks.
  # scope "/api", SlackishPhoenixWeb do
  #   pipe_through :api
  # end

  defp detect_user_in_session(conn, _params) do
    user = conn
       |> get_session(:current_user)
       |> SlackishPhoenix.Auth.get_user

    case user do
      nil -> conn
      user -> conn |> assign(:user, user)
    end
  end
end
