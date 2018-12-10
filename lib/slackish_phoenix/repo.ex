defmodule SlackishPhoenix.Repo do
  use Ecto.Repo,
    otp_app: :slackish_phoenix,
    adapter: Ecto.Adapters.Postgres
end
