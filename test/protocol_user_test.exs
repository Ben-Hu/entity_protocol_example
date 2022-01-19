defmodule UserTest do
  use ExUnit.Case, async: true

  describe "ProtocolUser" do
    alias ProtocolUser, as: User

    test "valid init" do
      assert {:ok, foo} = Entity.init(%User{email: "foo@example.com", username: "foo"})
      assert {:ok, bar} = Entity.init(%User{email: "bar@example.com", username: "bar"})

      assert is_binary(foo.id)
      assert is_binary(bar.id)
      assert foo.id != bar.id

      assert foo.timezone == "Etc/UTC"
      assert bar.timezone == "Etc/UTC"
    end

    test "init requires email" do
      assert Entity.init(%User{email: nil, username: "foo"}) ==
               {:error, {:invalid_opts, [:email]}}
    end

    test "init requires username" do
      assert Entity.init(%User{email: "foo@example.com", username: nil}) ==
               {:error, {:invalid_opts, [:username]}}
    end

    setup do
      %{user: Entity.init!(%User{email: "foo@example.com", username: "foo"})}
    end

    test "valid update", %{user: user} do
      {:ok, updated} = Entity.update(user, email: "bar@example.com", username: "bar")

      assert updated == %User{
               id: user.id,
               email: "bar@example.com",
               username: "bar",
               timezone: user.timezone
             }
    end

    test "update requires email", %{user: user} do
      assert Entity.update(user, email: nil) == {:error, {:invalid_opts, [:email]}}
    end

    test "update requires username", %{user: user} do
      assert Entity.update(user, username: nil) == {:error, {:invalid_opts, [:username]}}
    end
  end

  describe "BehaviourUser" do
    alias BehaviourUser, as: User

    test "valid init" do
      assert {:ok, foo} = User.init(%User{email: "foo@example.com", username: "foo"})
      assert {:ok, bar} = User.init(%User{email: "bar@example.com", username: "bar"})

      assert is_binary(foo.id)
      assert is_binary(bar.id)
      assert foo.id != bar.id

      assert foo.timezone == "Etc/UTC"
      assert bar.timezone == "Etc/UTC"
    end

    test "init requires email" do
      assert User.init(%User{email: nil, username: "foo"}) ==
               {:error, {:invalid_opts, [:email]}}
    end

    test "init requires username" do
      assert User.init(%User{email: "foo@example.com", username: nil}) ==
               {:error, {:invalid_opts, [:username]}}
    end

    setup do
      %{user: User.init!(%User{email: "foo@example.com", username: "foo"})}
    end

    test "valid update", %{user: user} do
      {:ok, updated} = User.update(user, email: "bar@example.com", username: "bar")

      assert updated == %User{
               id: user.id,
               email: "bar@example.com",
               username: "bar",
               timezone: user.timezone
             }
    end

    test "update requires email", %{user: user} do
      assert User.update(user, email: nil) == {:error, {:invalid_opts, [:email]}}
    end

    test "update requires username", %{user: user} do
      assert User.update(user, username: nil) == {:error, {:invalid_opts, [:username]}}
    end
  end
end
