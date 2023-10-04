defmodule Yggdrasil.GameHub.Tictac.PlayerTest do
  use ExUnit.Case

  alias Yggdrasil.GameHub.Tictac.Player

  describe "new/2" do
    test "creates a new player with valid arguments" do
      player = Player.new("Alice", "X")
      assert %Player{name: "Alice", letter: "X"} = player
    end

    test "returns nil for invalid arguments" do
      player = Player.new(nil, "X")
      assert is_nil(player)
    end
  end

  describe "valid?/1" do
    test "returns true for a valid player" do
      player = %Player{name: "Alice", letter: "X"}
      assert Player.valid?(player) == true
    end

    test "returns false for an invalid player" do
      player = %Player{name: nil, letter: "X"}
      assert Player.valid?(player) == false
    end
  end
end
