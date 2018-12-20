defmodule SlackishPhoenixWeb.CompanyChannelTest do
  use SlackishPhoenixWeb.ChannelCase

  alias SlackishPhoenix.Companies
  alias SlackishPhoenixWeb.CompanyChannel

  import SlackishPhoenix.Factory

  setup do
    user = insert(:user)
    socket = socket(SlackishPhoenixWeb.UserSocket, "usertoken", %{user_id: user.id})

    {:ok, socket: socket, user: user}
  end

  test "join returns current user and company", %{socket: socket, user: user} do
    company = insert(:company, %{owner_id: user.id})
    Companies.add_user_to_company(user, company)

    {:ok, %{company: replied_company, user: replied_user}, _socket} =
      CompanyChannel.join(
        "company:#{company.id}",
        %{},
        socket
      )

    assert company.id == replied_company.id
    assert user.id == replied_user.id
  end

  test "join returns error when user is not member of company", %{socket: socket} do
    company = insert(:company)

    assert {:error, _reason} = CompanyChannel.join("company:#{company.id}", %{}, socket)
  end

  test "handle_in/3 creates the channel", %{socket: socket, user: user} do
    company = insert(:company, %{owner_id: user.id})
    Companies.add_user_to_company(user, company)

    {:ok, _, socket} = socket |> subscribe_and_join(CompanyChannel, "company:#{company.id}")

    socket |> push("company:#{company.id}", %{"channel" => "general"})

    assert_broadcast channel_name, %{channel: %SlackishPhoenix.Chat.Channel{} = channel}

    assert channel_name == "company:#{company.id}:new"
    assert channel.name == "general"
    assert channel.company_id == company.id
  end
end
