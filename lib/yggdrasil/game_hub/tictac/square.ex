defmodule Yggdrasil.GameHub.Tictac.Square do
  @moduledoc """
  This module represents a square on a Tic Tac Toe board.
  """  
  use TypedStruct

  alias __MODULE__

  typedstruct do
    field(:name, atom())
    field(:letter, String.t())
  end

  @doc """
  Builds and returns a board square.

  ## Examples

      iex> build(:sq11)
      %__MODULE__{name: :sq11, letter: nil}

      iex> build(:sq22, "X")
      %__MODULE__{name: :sq22, letter: "X"}

  """
  @spec build(name :: atom(), letter :: String() | nil) :: t()
  def build(name, letter \\ nil) do
    struct(__MODULE__, %{name: name, letter: letter})
  end

  @doc """
  Returns if the square is open. True if no player has claimed the square. False
  if a player occupies it.

  ## Examples

      iex> is_open?(%__MODULE__{name: :sq11, letter: nil})
      true

      iex> is_open?(%__MODULE__{name: :sq11, letter: "O"})
      false

      iex> is_open?(%__MODULE__{name: :sq11, letter: "X"})
      false

  """
  @spec is_open?(t()) :: boolean()
  def is_open?(%__MODULE__{letter: nil}), do: true
  def is_open?(_), do: false
end
