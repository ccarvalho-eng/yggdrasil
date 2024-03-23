defmodule Yggdrasil.GameHub.Tictac.PlayerTest do
  use ExUnit.Case

  alias Yggdrasil.GameHub.Tictac.Player

  @valid_attrs %{name: "Kristoff", letter: "X"}
  @invalid_attrs %{name: nil, letter: nil}

  describe "build/1" do
    test "returns valid changeset with valid attrs" do
      changeset = Player.build(@valid_attrs)
      id = changeset.changes.id

      assert changeset.valid?
      assert changeset.changes.name == "Kristoff"
      assert changeset.changes.letter == "X"
      assert is_binary(id) and byte_size(id) > 0
    end

    test "returns invalid changeset with valid attrs" do
      changeset = Player.build(@invalid_attrs)
      refute changeset.valid?
    end
  end

  describe "insert/1" do
    test "returns player struct with valid changeset" do
      changeset = Player.build(@valid_attrs)
      assert {:ok, %Player{}} = Player.insert(changeset)
    end

    test "returns invalid changeset with invalid changeset" do
      changeset = Player.build(@invalid_attrs)
      assert {:error, %Ecto.Changeset{}} = Player.insert(changeset)
    end
  end
end
