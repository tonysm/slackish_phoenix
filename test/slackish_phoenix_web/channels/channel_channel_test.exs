defmodule SlackishPhoenixWeb.ChannelChannelTest do
  use SlackishPhoenixWeb.ChannelCase

  setup do
    user = user_fixture()
    company = company_fixture(%{owner_id: user.id})
    channel = channel_fixture(%{company_id: company.id})

    {:ok, _, socket} =
      socket(SlackishPhoenixWeb.UserSocket, "usertoken", %{user_id: user.id})
      |> subscribe_and_join(SlackishPhoenixWeb.ChannelChannel, "channels:#{channel.id}")

    {:ok, socket: socket, company: company, user: user, channel: channel}
  end

  defp user_fixture(attrs \\ %{}) do
    {:ok, user} =
      attrs
      |> Enum.into(%{
        email: "some email",
        google_id: "some google_id",
        image_url: "some image_url",
        name: "some name"
      })
      |> SlackishPhoenix.Auth.create_user()

    user
  end

  defp company_fixture(attrs) do
    {:ok, company} =
      attrs
      |> Enum.into(%{name: "madewithlove"})
      |> SlackishPhoenix.Companies.create_company()

    company
  end

  defp channel_fixture(attrs) do
    {:ok, channel} =
      attrs
      |> Enum.into(%{name: "general"})
      |> SlackishPhoenix.Chat.create_channel()

    channel
  end

  test "join/3 assigns the channel_id to the socket", %{socket: socket, channel: channel} do
    assert socket.assigns[:channel_id] == channel.id
  end

  test "handle_in/3 broadcasts the given message", %{socket: socket, channel: channel, user: user} do
    push(socket, "channels:#{channel.id}", %{
      "message" => "hello from the other side",
      "uuid" => "some-fake-uuid"
    })

    assert_broadcast channel_name, event

    assert channel_name == "channels:#{channel.id}:new_message"
    assert event.id == "some-fake-uuid"
    assert event.message == "hello from the other side"
    assert event.user.id == user.id
  end
end
