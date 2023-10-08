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

      iex> Player.build("Alice", "X")
      %__MODULE__{name: "Alice", letter: "X"}

  """
  @spec build(name :: String.t(), letter :: String.t()) :: %__MODULE__{}
  def build(name, letter) when is_binary(name) and is_binary(letter) do
    struct(__MODULE__, %{name: name, letter: letter})
  end

  def build(_, _), do: nil

  @doc """
  Checks if a player is valid.

  A player is considered valid if both name and letter are not nil.

  ## Examples

      iex> player = build("Alice", "X")
      %__MODULE__{name: "Alice", letter: "X"}

      iex> valid?(player)
      true

  """
  @spec valid?(player :: t()) :: boolean
  def valid?(%__MODULE__{name: name, letter: letter})
      when is_binary(name) and is_binary(letter) do
    true
  end

  def valid?(_), do: false
end
