defmodule SlackishPhoenix.UserFactory do
  defmacro __using__(_opts) do
    quote do
      def user_factory do
        %SlackishPhoenix.Auth.User{
          email: sequence(:email, &"john-#{&1}@example.com"),
          google_id: "some-fake-google-id",
          image_url: "http://placekitten.com/g/200/200",
          name: "John Doe"
        }
      end
    end
  end
end
