defmodule SlackishPhoenixWeb.Presence do
  use Phoenix.Presence,
    otp_app: :slackish_phoenix,
    pubsub_server: SlackishPhoenix.PubSub
end
