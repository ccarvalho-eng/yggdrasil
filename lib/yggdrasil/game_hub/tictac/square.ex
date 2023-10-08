defmodule Yggdrasil.GameHub.Tictac.Square do
  @moduledoc """
  This module represents a square on a Tic Tac Toe board.
  """
  use TypedStruct

  typedstruct do
    field(:name, atom())
    field(:letter, String.t())
  end

  @doc """
  Builds and returns a board square.

  ## Examples

      iex> Yggdrasil.GameHub.Tictac.Square.build(:sq11)
      %Yggdrasil.GameHub.Tictac.Square{name: :sq11, letter: nil}

      iex> Yggdrasil.GameHub.Tictac.Square.build(:sq22, "X")
      %Yggdrasil.GameHub.Tictac.Square{name: :sq22, letter: "X"}

  """
  @spec build(name :: atom(), letter :: String.t() | nil) :: t()
  def build(name, letter \\ nil) do
    struct(__MODULE__, %{name: name, letter: letter})
  end

  @doc """
  Returns if the square is open. True if no player has claimed the square. False
  if a player occupies it.

  ## Examples

      iex> Yggdrasil.GameHub.Tictac.Square.is_open?(%Yggdrasil.GameHub.Tictac.Square{name: :sq11, letter: nil})
      true

      iex> Yggdrasil.GameHub.Tictac.Square.is_open?(%Yggdrasil.GameHub.Tictac.Square{name: :sq11, letter: "O"})
      false

      iex> Yggdrasil.GameHub.Tictac.Square.is_open?(%Yggdrasil.GameHub.Tictac.Square{name: :sq11, letter: "X"})
      false

  """
  @spec is_open?(t()) :: boolean()
  def is_open?(%__MODULE__{letter: nil}), do: true
  def is_open?(_), do: false
end
