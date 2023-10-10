defmodule Yggdrasil.GameHub.TictacTest do
  use ExUnit.Case

  alias Yggdrasil.GameHub.Tictac
  alias Yggdrasil.GameHub.Tictac.{Player, Square}

  doctest Tictac

  describe "find_winning_combination/2" do
    test "returns winning combination when player did win" do
      player_0 = Player.build("Kristoff", "X")

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
        players: [player_0]
      }

      assert [:sq11, :sq12, :sq13] == Tictac.find_winning_combination(player_0, game)
    end

    test "returns :not_found when no winning combination" do
      player_0 = Player.build("Kristoff", "X")
      player_1 = Player.build("Larah", "O")

      game = %Tictac{
        board: [
          %Square{letter: "X", name: :sq11},
          %Square{letter: "O", name: :sq12},
          %Square{letter: "X", name: :sq13},
          %Square{letter: "X", name: :sq21},
          %Square{letter: "X", name: :sq22},
          %Square{letter: "O", name: :sq23},
          %Square{letter: "O", name: :sq31},
          %Square{letter: "X", name: :sq32},
          %Square{letter: "O", name: :sq33}
        ],
        players: [player_0, player_1]
      }

      assert :not_found == Tictac.find_winning_combination(player_0, game)
    end
  end
end
