defmodule SlackishPhoenixWeb.ChannelChannel do
  use SlackishPhoenixWeb, :channel

  alias SlackishPhoenix.Auth
  alias SlackishPhoenix.Chat

  def join("channels:" <> channel_id, _payload, socket) do
    user_id = socket.assigns[:user_id]

    case Chat.can_access_channel_by_user_id(user_id, channel_id) do
      true ->
        {:ok, %{}, assign(socket, :channel_id, channel_id |> String.to_integer())}

      false ->
        {:error, reason: "You cannot access this channel."}
    end
  end

  def handle_in(_name, %{"message" => message, "uuid" => id}, socket) do
    channel_id = socket.assigns[:channel_id]

    user = Auth.get_user!(socket.assigns[:user_id])

    broadcast!(socket, "channels:#{channel_id}:new_message", %{
      id: id,
      message: message,
      user: user,
      sent_at: inspect(System.system_time(:second))
    })

    {:reply, :ok, socket}
  end
end
