defmodule SlackishPhoenix.ChatTest do
  use SlackishPhoenix.DataCase

  alias SlackishPhoenix.Chat

  import SlackishPhoenix.Factory

  describe "channels" do
    alias SlackishPhoenix.Chat.Channel

    @update_attrs %{company_id: 43, name: "some updated name"}
    @invalid_attrs %{company_id: nil, name: nil}

    test "list_channels/0 returns all channels" do
      channel = insert(:channel)
      assert Chat.list_channels() == [channel]
    end

    test "get_channel!/1 returns the channel with given id" do
      channel = insert(:channel)
      assert Chat.get_channel!(channel.id) == channel
    end

    test "create_channel/1 with valid data creates a channel" do
      assert {:ok, %Channel{} = channel} =
               Chat.create_channel(%{
                 company_id: 42,
                 name: "some name"
               })

      assert channel.company_id == 42
      assert channel.name == "some name"
    end

    test "create_channel/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Chat.create_channel(@invalid_attrs)
    end

    test "update_channel/2 with valid data updates the channel" do
      channel = insert(:channel)
      assert {:ok, %Channel{} = channel} = Chat.update_channel(channel, @update_attrs)
      assert channel.company_id == 43
      assert channel.name == "some updated name"
    end

    test "update_channel/2 with invalid data returns error changeset" do
      channel = insert(:channel)
      assert {:error, %Ecto.Changeset{}} = Chat.update_channel(channel, @invalid_attrs)
      assert channel == Chat.get_channel!(channel.id)
    end

    test "delete_channel/1 deletes the channel" do
      channel = insert(:channel)
      assert {:ok, %Channel{}} = Chat.delete_channel(channel)
      assert_raise Ecto.NoResultsError, fn -> Chat.get_channel!(channel.id) end
    end

    test "change_channel/1 returns a channel changeset" do
      channel = insert(:channel)
      assert %Ecto.Changeset{} = Chat.change_channel(channel)
    end

    test "list_channels_of_company/1 returns only channels of the given company" do
      company_with_channels = insert(:company)
      insert_list(3, :channel, %{company_id: company_with_channels.id})
      another_company = insert(:company)
      insert_list(2, :channel, %{company_id: another_company.id})

      channels = Chat.list_channels_of_company(company_with_channels.id)

      assert length(channels) == 3
    end
  end
end
