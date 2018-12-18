defmodule SlackishPhoenixWeb.CompanyChannelTest do
  use SlackishPhoenixWeb.ChannelCase

  alias SlackishPhoenix.Auth
  alias SlackishPhoenix.Companies

  setup do
    user = user_fixture()
    socket = socket(SlackishPhoenixWeb.UserSocket, "usertoken", %{user_id: user.id})

    {:ok, socket: socket, user: user}
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
      |> Auth.create_user()

    user
  end

  defp company_fixture(attrs) do
    {:ok, company} =
      attrs
      |> Enum.into(%{name: "madewithlove"})
      |> Companies.create_company()

    company
  end

  test "join returns current user and company", %{socket: socket, user: user} do
    company = company_fixture(%{owner_id: user.id})

    {:ok, %{company: replied_company, user: replied_user}, _socket} =
      SlackishPhoenixWeb.CompanyChannel.join(
        "company:#{company.id}",
        %{},
        socket
      )

    assert company.id == replied_company.id
    assert user.id == replied_user.id
  end

  test "handle_in/3 creates the channel", %{socket: socket, user: user} do
    company = company_fixture(%{owner_id: user.id})

    {:ok, _, socket} =
      socket |> subscribe_and_join(SlackishPhoenixWeb.CompanyChannel, "company:#{company.id}")

    socket |> push("company:#{company.id}", %{"channel" => "general"})

    assert_broadcast _, %{channel: %SlackishPhoenix.Chat.Channel{} = channel}
    assert channel.name == "general"
    assert channel.company_id == company.id
  end
end
