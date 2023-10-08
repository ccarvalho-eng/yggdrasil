defmodule Yggdrasil.GameHub.Tictac do
  @moduledoc """
  Module for managing the state of a Tic-Tac-Toe game.
  """

  use TypedStruct

  alias Yggdrasil.GameHub.Tictac.{Player, Square}

  @row_size 1..3
  @col_size 1..3

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
                %Square{letter: nil, name: :sq11}, %Square{letter: nil, name: :sq12}, %Square{letter: nil, name: :sq13},
                %Square{letter: nil, name: :sq21}, %Square{letter: nil, name: :sq22}, %Square{letter: nil, name: :sq23},
                %Square{letter: nil, name: :sq31}, %Square{letter: nil, name: :sq32}, %Square{letter: nil, name: :sq33}
              ],
              player_turn: nil,
              players: []
            }

  """
  @spec init() :: t()
  def init do
    struct(
      __MODULE__,
      %{
        players: [],
        player_turn: nil,
        board: build_board()
      }
    )
  end

  defp build_board do
    for(row <- @row_size, col <- @col_size, do: Square.build(:"sq#{row}#{col}"))
  end
end
