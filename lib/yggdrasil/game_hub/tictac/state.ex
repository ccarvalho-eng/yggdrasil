defmodule Yggdrasil.GameHub.Tictac.State do
  @moduledoc """
  Module de game state for a tic-tac-toe game.
  """

  use TypedStruct

  alias Yggdrasil.GameHub.Tictac.{Player, Square}

  typedstruct do
    field(:players, [Player.t()])
    field(:player_turn, integer() | nil)
    field(:board, [Square.t()])
  end
end
