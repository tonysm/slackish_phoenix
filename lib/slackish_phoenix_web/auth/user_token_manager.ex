defmodule SlackishPhoenixWeb.Auth.UserTokenManager do
  alias SlackishPhoenix.Auth.User

  @doc false
  def issue_token(%User{} = user) do
    token =
      Phoenix.Token.sign(
        SlackishPhoenixWeb.Endpoint,
        SlackishPhoenixWeb.Endpoint.config(:secret_key_base),
        user.id
      )

    {:ok, token}
  end

  @doc false
  def decode_token(socket, token) do
    case parse_token(socket, token) do
      {:ok, user_id} ->
        {:ok, user_id}

      {:error, _} ->
        {:error}
    end
  end

  @doc false
  defp parse_token(socket, token) do
    Phoenix.Token.verify(
      socket,
      SlackishPhoenixWeb.Endpoint.config(:secret_key_base),
      token,
      max_age: 86400
    )
  end
end
