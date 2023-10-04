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
  Creates a new player.

  ## Examples

      iex> Player.new("Alice", "X")
      %Yggdrasil.Games.Tictac.Player{name: "Alice", letter: "X"}

  """
  @spec new(name :: String.t(), letter :: String.t()) :: %__MODULE__{}
  def new(name, letter) when is_binary(name) and is_binary(letter) do
    struct(__MODULE__, %{name: name, letter: letter})
  end

  def new(_, _), do: nil

  @doc """
  Checks if a player is valid.

  A player is considered valid if both name and letter are not nil.

  ## Examples

      iex> player = Player.new("Alice", "X")
      %Yggdrasil.Games.Tictac.Player{name: "Alice", letter: "X"}

      iex> Player.valid?(player)
      true

  """
  @spec valid?(player :: t()) :: boolean
  def valid?(%__MODULE__{name: name, letter: letter})
      when is_binary(name) and is_binary(letter) do
    true
  end

  def valid?(_), do: false
end
