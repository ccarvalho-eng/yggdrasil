defmodule Yggdrasil.GameHub.Tictac.MatchTest do
  use ExUnit.Case

  alias Yggdrasil.GameHub.Tictac.{Match, Player, Square}

  doctest Match

  @horizontal_wins [[:sq11, :sq12, :sq13], [:sq21, :sq22, :sq23], [:sq31, :sq32, :sq33]]
  @vertical_wins [[:sq11, :sq21, :sq31], [:sq12, :sq22, :sq32], [:sq13, :sq23, :sq33]]
  @diagonal_wins [[:sq11, :sq22, :sq33], [:sq13, :sq22, :sq31]]
  @random_win Enum.random(@horizontal_wins ++ @vertical_wins ++ @diagonal_wins)

  describe "find_winning_combinations/2" do
    setup do
      player = Player.build("Kristoff", "X")
      match = %Match{players: [player]}
      {:ok, player: player, match: match}
    end

    for horizontal_win <- @horizontal_wins do
      description = "returns #{Enum.join(horizontal_win, ", ")} when player wins horizontally"

      test description, %{player: player, match: match} do
        assert_winning_combination(match, player, unquote(horizontal_win))
      end
    end

    for vertical_win <- @vertical_wins do
      description = "returns #{Enum.join(vertical_win, ", ")} when player wins vertically"

      test description, %{player: player, match: match} do
        assert_winning_combination(match, player, unquote(vertical_win))
      end
    end

    for diagonal_win <- @diagonal_wins do
      description = "returns #{Enum.join(diagonal_win, ", ")} when player wins diagonally"

      test description, %{player: player, match: match} do
        assert_winning_combination(match, player, unquote(diagonal_win))
      end
    end

    test "returns :not_found when no winning combination", %{player: player, match: match} do
      updated_match = Map.update!(match, :board, fn _ -> [] end)
      assert Match.find_winning_combination(updated_match, player) == :not_found
    end
  end

  describe "result/2" do
    setup do
      player_1 = Player.build("Kristoff", "X")
      player_2 = Player.build("Larah", "O")

      {:ok, match} = player_1 |> Match.init() |> Match.join(player_2)
      {:ok, match: match, player_1: player_1, player_2: player_2}
    end

    test "returns match winner", %{match: match, player_1: player_1, player_2: player_2} do
      for player <- [player_1, player_2] do
        winning_combination = Enum.map(@random_win, &%Square{letter: player.letter, name: &1})
        match = %Match{match | board: winning_combination}

        assert Match.result(match) == player
      end
    end

    test "returns `:draw` when no winning combinations", %{match: match} do
      draw_combination = [
        %Square{letter: "X", name: :sq11},
        %Square{letter: "O", name: :sq12},
        %Square{letter: "X", name: :sq13},
        %Square{letter: "X", name: :sq21},
        %Square{letter: "O", name: :sq22},
        %Square{letter: "O", name: :sq23},
        %Square{letter: "O", name: :sq31},
        %Square{letter: "X", name: :sq32},
        %Square{letter: "O", name: :sq33}
      ]

      match = %Match{match | board: draw_combination}
      assert Match.result(match) == :draw
    end

    test "returns `:playing` if match is not over", %{match: match} do
      assert Match.result(match) == :playing
    end
  end

  describe "play/3" do
  end

  defp assert_winning_combination(match, player, win_combination) do
    squares = Enum.map(win_combination, &%Square{letter: "X", name: &1})
    updated_match = Map.update!(match, :board, fn _ -> squares end)

    assert Match.find_winning_combination(updated_match, player) == win_combination
  end
end
