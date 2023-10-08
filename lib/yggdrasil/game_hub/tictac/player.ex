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

      iex> Yggdrasil.GameHub.Tictac.Player.build("Larah", "X")
      %Yggdrasil.GameHub.Tictac.Player{name: "Larah", letter: "X"}

      iex> Yggdrasil.GameHub.Tictac.Player.build(nil, nil)
      %Yggdrasil.GameHub.Tictac.Player{name: nil, letter: nil}

  """
  @spec build(name :: String.t() | nil, letter :: String.t() | nil) :: %__MODULE__{}
  def build(name \\ nil, letter \\ nil) do
    struct(__MODULE__, %{name: name, letter: letter})
  end
end
