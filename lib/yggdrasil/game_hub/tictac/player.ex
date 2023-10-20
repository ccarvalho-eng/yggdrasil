defmodule Yggdrasil.GameHub.Tictac.Player do
  @moduledoc """
  This module defines the Player struct for a Tic-Tac-Toe game.

  The `Player` struct represents a player in the game, including their `name`
  and `letter` (X or O).
  """

  use TypedStruct

  typedstruct do
    field(:name, String.t())
    field(:letter, String.t())
  end

  @doc """
  Builds a new player.

  ## Examples

      iex> alias Yggdrasil.GameHub.Tictac.Player
      iex> Player.build("Larah", "X")
      %Player{name: "Larah", letter: "X"}

      iex> alias Yggdrasil.GameHub.Tictac.Player
      iex> Player.build(nil, nil)
      %Player{name: nil, letter: nil}

  """
  @spec build(name :: String.t() | nil, letter :: String.t() | nil) :: %__MODULE__{}
  def build(name \\ nil, letter \\ nil) do
    struct(__MODULE__, %{name: name, letter: letter})
  end
end
