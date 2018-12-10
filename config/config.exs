# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :slackish_phoenix,
  ecto_repos: [SlackishPhoenix.Repo]

# Configures the endpoint
config :slackish_phoenix, SlackishPhoenixWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "HUyYVA2N57iHuu/O3k63vrMwu37zRiKHTooIXlubTHOLidzpOMveRwyKg3iQXuQ1",
  render_errors: [view: SlackishPhoenixWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: SlackishPhoenix.PubSub, adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

config :ueberauth, Ueberauth,
   providers: [
     google: {Ueberauth.Strategy.Google, []}
   ]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
