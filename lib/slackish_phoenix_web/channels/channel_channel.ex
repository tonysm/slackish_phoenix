defmodule SlackishPhoenixWeb.ChannelChannel do
  use SlackishPhoenixWeb, :channel

  alias SlackishPhoenix.Auth

  def join("channels:" <> channel_id, payload, socket) do
    {:ok, %{}, assign(socket, :channel_id, channel_id)}
  end

  def handle_in(_name, %{"message" => message, "uuid" => id}, socket) do
    channel_id = socket.assigns[:channel_id]

    user = Auth.get_user!(socket.assigns[:user_id])

    payload = %{
      id: id,
      message: message,
      user: user,
      sent_at: inspect(System.system_time(:second))
    }

    broadcast!(socket, "channels:#{channel_id}:new_message", payload)

    {:reply, :ok, socket}
  end
end