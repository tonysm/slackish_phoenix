defmodule SlackishPhoenix.AuthTest do
  use SlackishPhoenix.DataCase

  alias SlackishPhoenix.Auth

  describe "users" do
    alias SlackishPhoenix.Auth.User

    @valid_attrs %{
      email: "some email",
      google_id: "some google_id",
      image_url: "some image_url",
      name: "some name"
    }
    @update_attrs %{
      email: "some updated email",
      google_id: "some updated google_id",
      image_url: "some updated image_url",
      name: "some updated name"
    }
    @invalid_attrs %{email: nil, google_id: nil, image_url: nil, name: nil}
    @ueberauth_response %{
      uid: "abc123",
      info: %{
        first_name: "Tony",
        last_name: "Messias",
        email: "tony@mwl.be",
        image: "http://example.com/avatar.png"
      }
    }

    def user_fixture(attrs \\ %{}) do
      {:ok, user} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Auth.create_user()

      user
    end

    test "list_users/0 returns all users" do
      user = user_fixture()
      assert Auth.list_users() == [user]
    end

    test "get_user!/1 returns the user with given id" do
      user = user_fixture()
      assert Auth.get_user!(user.id) == user
    end

    test "create_user/1 with valid data creates a user" do
      assert {:ok, %User{} = user} = Auth.create_user(@valid_attrs)
      assert user.email == "some email"
      assert user.google_id == "some google_id"
      assert user.image_url == "some image_url"
      assert user.name == "some name"
    end

    test "create_user/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Auth.create_user(@invalid_attrs)
    end

    test "update_user/2 with valid data updates the user" do
      user = user_fixture()
      assert {:ok, %User{} = user} = Auth.update_user(user, @update_attrs)
      assert user.email == "some updated email"
      assert user.google_id == "some updated google_id"
      assert user.image_url == "some updated image_url"
      assert user.name == "some updated name"
    end

    test "update_user/2 with invalid data returns error changeset" do
      user = user_fixture()
      assert {:error, %Ecto.Changeset{}} = Auth.update_user(user, @invalid_attrs)
      assert user == Auth.get_user!(user.id)
    end

    test "delete_user/1 deletes the user" do
      user = user_fixture()
      assert {:ok, %User{}} = Auth.delete_user(user)
      assert_raise Ecto.NoResultsError, fn -> Auth.get_user!(user.id) end
    end

    test "change_user/1 returns a user changeset" do
      user = user_fixture()
      assert %Ecto.Changeset{} = Auth.change_user(user)
    end

    test "find_or_create_from_auth/1 creates user when new" do
      assert {:ok, %User{} = user} = Auth.find_or_create_from_auth(@ueberauth_response)
      assert user.email == "tony@mwl.be"
      assert user.google_id == "abc123"
      assert user.image_url == "http://example.com/avatar.png"
      assert user.name == "Tony Messias"
    end

    test "find_or_create_from_auth/1 returns existing user when already created" do
      user_fixture(%{google_id: "abc123"})

      assert {:ok, %User{} = user} = Auth.find_or_create_from_auth(@ueberauth_response)
      assert user.google_id == "abc123"

      total_users = Auth.list_users()

      assert length(total_users) == 1
    end
  end
end
