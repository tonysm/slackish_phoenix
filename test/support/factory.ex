defmodule SlackishPhoenix.Factory do
  use ExMachina.Ecto, repo: SlackishPhoenix.Repo
  use SlackishPhoenix.UserFactory
  use SlackishPhoenix.CompanyFactory
  use SlackishPhoenix.ChannelFactory
end
