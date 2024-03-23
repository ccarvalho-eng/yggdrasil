defmodule Yggdrasil.GameHub.Tictac.Player do
  @moduledoc """
  This module defines the Player struct for a Tic-Tac-Toe game.

  The `Player` struct represents a player in the game, including their `name`
  and `letter` (X or O).
  """

  use Ecto.Schema
  import Ecto.Changeset

  @type t :: %__MODULE__{name: String.t(), letter: String.t()}

  @required_fields ~w(name)a
  @optional_fields ~w(letter)a

  @foreign_key_type :binary_id
  embedded_schema do
    field :name, :string
    field :letter, :string
  end

  @doc """
  Builds a new player.
  """
  @spec build(%{name: String, letter: String.t()}) :: Ecto.Changeset.t()
  def build(attrs) do
    changeset(%__MODULE__{}, attrs)
  end

  @doc """
  Inserts the `%Player{}` struct instance with a valid changeset.
  """
  @spec insert(Ecto.Changeset.t()) :: {:ok, t()} | {:error, Ecto.Changeset.t()}
  def insert(changeset) do
    apply_action(changeset, :insert)
  end

  defp changeset(player, attrs) do
    player
    |> cast(attrs, @required_fields ++ @optional_fields)
    |> validate_required(@required_fields)
    |> generate_id()
  end

  defp generate_id(%Ecto.Changeset{valid?: true} = cs) do
    if get_field(cs, :id), do: cs, else: put_change(cs, :id, Ecto.UUID.generate())
  end

  defp generate_id(changeset), do: changeset
end
