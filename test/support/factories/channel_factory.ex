defmodule SlackishPhoenix.ChannelFactory do
  defmacro __using__(_opts) do
    quote do
      def channel_factory do
        %SlackishPhoenix.Chat.Channel{
          name: "madewithlove"
        }
      end
    end
  end
end
