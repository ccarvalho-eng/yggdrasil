defmodule Yggdrasil.GameHub.Tictac do
  @moduledoc """
  Module for managing the state of a Tic-Tac-Toe game.
  """

  use TypedStruct

  alias Yggdrasil.GameHub.Tictac.{Player, Square}

  @row_range 1..3
  @col_range 1..3
  @winning_combinations [
    # Straight across wins
    [:sq11, :sq12, :sq13],
    [:sq21, :sq22, :sq23],
    [:sq31, :sq32, :sq33],

    # Vertical wins
    [:sq11, :sq21, :sq31],
    [:sq12, :sq22, :sq32],
    [:sq13, :sq23, :sq33],

    # Diagonal wins
    [:sq11, :sq22, :sq33],
    [:sq13, :sq22, :sq31]
  ]

  typedstruct do
    field(:players, [Player.t()])
    field(:player_turn, integer() | nil)
    field(:board, [Square.t()])
  end

  @doc """
  Initializes a new game of Tic-Tac-Toe.

  ## Examples

      iex> alias Yggdrasil.GameHub.Tictac.Square
      iex> alias Yggdrasil.GameHub.Tictac
      iex> Tictac.init()
      %Tictac{
        board: [
          %Square{letter: nil, name: :sq11},
          %Square{letter: nil, name: :sq12},
          %Square{letter: nil, name: :sq13},
          %Square{letter: nil, name: :sq21},
          %Square{letter: nil, name: :sq22},
          %Square{letter: nil, name: :sq23},
          %Square{letter: nil, name: :sq31},
          %Square{letter: nil, name: :sq32},
          %Square{letter: nil, name: :sq33}
        ],
        player_turn: nil,
        players: []
      }

  """
  @spec init() :: t()
  def init do
    struct(__MODULE__, %{players: [], player_turn: nil, board: build_board()})
  end

  @doc """
  Returns a list of valid moves representing squares on the game board.

  This function calculates and returns a list of squares that are valid moves based on the current game state.

  ## Examples

      iex> alias Yggdrasil.GameHub.Tictac
      iex> game = Tictac.init()
      iex> Tictac.get_open_squares(game)
      [:sq33, :sq32, :sq31, :sq23, :sq22, :sq21, :sq13, :sq12, :sq11]

  """
  @spec get_open_squares(t()) :: list(atom())
  def get_open_squares(game) do
    Enum.reduce(game.board, [], fn square, acc ->
      if Square.is_open?(square), do: [square.name | acc], else: acc
    end)
  end

  @doc """
  Finds a winning combination for the specified player in the Tic-Tac-Toe game.

  ## Parameters

  - `player`: The player for whom the winning combination is sought.
  - `game`: The state of the Tic-Tac-Toe game.

  ## Returns

  - A list of atoms representing the winning combination, or
  - `:not_found` if no winning combination is found.

  """
  @spec find_winning_combination(Player.t(), t()) :: list(atom()) | :not_found
  def find_winning_combination(player, game) do
    case Enum.find(@winning_combinations, &did_player_win?(game.board, player.letter, &1)) do
      nil -> :not_found
      combination -> combination
    end
  end

  defp build_board do
    for row <- @row_range, col <- @col_range, do: Square.build(:"sq#{row}#{col}")
  end

  defp did_player_win?(board, letter, combination) do
    Enum.all?(combination, fn square ->
      has_matching_square?(board, square, letter)
    end)
  end

  defp has_matching_square?(board, square_name, letter) do
    case Enum.find(board, &(&1.name == square_name)) do
      %Square{letter: ^letter} -> true
      _ -> false
    end
  end
end
