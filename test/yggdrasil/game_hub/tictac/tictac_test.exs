defmodule Yggdrasil.GameHub.TictacTest do
  use ExUnit.Case

  alias Yggdrasil.GameHub.Tictac
  alias Yggdrasil.GameHub.Tictac.{Player, Square}

  doctest Tictac

  describe "find_winning_combination/2" do
    test "returns winning combination when player wins horizontally" do
      player = Player.build("Player1", "X")

      game = %Tictac{
        board: [
          %Square{letter: "X", name: :sq11},
          %Square{letter: "X", name: :sq12},
          %Square{letter: "X", name: :sq13},
          %Square{name: :sq21},
          %Square{name: :sq22},
          %Square{name: :sq23},
          %Square{name: :sq31},
          %Square{name: :sq32},
          %Square{name: :sq33}
        ],
        players: [player]
      }

      assert [:sq11, :sq12, :sq13] == Tictac.find_winning_combination(player, game)
    end

    test "returns winning combination when player wins vertically" do
      player = Player.build("Player1", "X")

      game = %Tictac{
        board: [
          %Square{letter: "X", name: :sq11},
          %Square{letter: "X", name: :sq21},
          %Square{letter: "X", name: :sq31},
          %Square{name: :sq12},
          %Square{name: :sq22},
          %Square{name: :sq32},
          %Square{name: :sq13},
          %Square{name: :sq23},
          %Square{name: :sq33}
        ],
        players: [player]
      }

      assert [:sq11, :sq21, :sq31] == Tictac.find_winning_combination(player, game)
    end

    test "returns winning combination when player wins diagonally" do
      player = Player.build("Player1", "X")

      game = %Tictac{
        board: [
          %Square{letter: "X", name: :sq11},
          %Square{letter: "X", name: :sq22},
          %Square{letter: "X", name: :sq33},
          %Square{name: :sq12},
          %Square{name: :sq21},
          %Square{name: :sq23},
          %Square{name: :sq13},
          %Square{name: :sq32},
          %Square{name: :sq31}
        ],
        players: [player]
      }

      assert [:sq11, :sq22, :sq33] == Tictac.find_winning_combination(player, game)
    end

    test "returns :not_found when no winning combination" do
      player = Player.build("Player1", "X")

      game = %Tictac{
        board: [
          %Square{letter: "X", name: :sq11},
          %Square{letter: "O", name: :sq12},
          %Square{letter: "O", name: :sq13},
          %Square{letter: "O", name: :sq21},
          %Square{letter: "X", name: :sq22},
          %Square{letter: "O", name: :sq23},
          %Square{letter: "X", name: :sq31},
          %Square{letter: "X", name: :sq32},
          %Square{letter: "O", name: :sq33}
        ],
        players: [player]
      }

      assert :not_found == Tictac.find_winning_combination(player, game)
    end
  end
end
