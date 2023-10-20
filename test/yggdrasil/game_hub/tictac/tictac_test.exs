defmodule Yggdrasil.GameHub.TictacTest do
  use ExUnit.Case

  alias Yggdrasil.GameHub.Tictac
  alias Yggdrasil.GameHub.Tictac.{Player, Square}

  doctest Tictac

  @horizontal_wins [[:sq11, :sq12, :sq13], [:sq21, :sq22, :sq23], [:sq31, :sq32, :sq33]]
  @vertical_wins [[:sq11, :sq21, :sq31], [:sq12, :sq22, :sq32], [:sq13, :sq23, :sq33]]
  @diagonal_wins [[:sq11, :sq22, :sq33], [:sq13, :sq22, :sq31]]

  setup do
    player = Player.build("Player1", "X")
    game = %Tictac{players: [player]}
    {:ok, player: player, game: game}
  end

  for horizontal_win <- @horizontal_wins do
    description = "returns #{Enum.join(horizontal_win, ", ")} when player wins horizontally"

    test description, %{player: player, game: game} do
      assert_winning_combination(player, game, unquote(horizontal_win))
    end
  end

  for vertical_win <- @vertical_wins do
    description = "returns #{Enum.join(vertical_win, ", ")} when player wins vertically"

    test description, %{player: player, game: game} do
      assert_winning_combination(player, game, unquote(vertical_win))
    end
  end

  for diagonal_win <- @diagonal_wins do
    description = "returns #{Enum.join(diagonal_win, ", ")} when player wins diagonally"

    test description, %{player: player, game: game} do
      assert_winning_combination(player, game, unquote(diagonal_win))
    end
  end

  test "returns :not_found when no winning combination", %{player: player, game: game} do
    updated_game = Map.update!(game, :board, fn _ -> [] end)
    assert Tictac.find_winning_combination(player, updated_game) == :not_found
  end

  defp assert_winning_combination(player, game, win_combination) do
    squares = Enum.map(win_combination, &%Square{letter: "X", name: &1})
    updated_game = Map.update!(game, :board, fn _ -> squares end)

    assert Tictac.find_winning_combination(player, updated_game) == win_combination
  end
end
