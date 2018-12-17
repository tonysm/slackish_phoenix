defmodule SlackishPhoenixWeb.Auth.UserTokenManagerTest do
  use SlackishPhoenixWeb.ConnCase, async: true

  alias SlackishPhoenix.Auth.User
  alias SlackishPhoenixWeb.Auth.UserTokenManager

  test "issue_token/1 generates a short-lived token for the given user", %{} do
    user = %User{id: 123}

    assert {:ok, token} = UserTokenManager.issue_token(user)
  end

  test "decode_token/2 returns returns the ID of the user that owns the token", %{} do
    user = %User{id: 123}
    socket = %Phoenix.Socket{endpoint: SlackishPhoenixWeb.Endpoint}

    {:ok, token} = UserTokenManager.issue_token(user)

    assert {:ok, id} = UserTokenManager.decode_token(socket, token)
    assert user.id == id
  end

  test "decode_token/2 returns error when token is invalid", %{} do
    token = "invalid-token"
    socket = %Phoenix.Socket{endpoint: SlackishPhoenixWeb.Endpoint}

    assert :error == UserTokenManager.decode_token(socket, token)
  end
end
