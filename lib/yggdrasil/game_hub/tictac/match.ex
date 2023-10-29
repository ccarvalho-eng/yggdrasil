defmodule Yggdrasil.GameHub.Tictac.Match do
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

  defmodule Status do
    @moduledoc """
    Match status.
    """
    @type t :: :not_started | :playing | :done
  end

  typedstruct do
    field(:players, [Player.t()])
    field(:player_turn, integer() | nil)
    field(:board, [Square.t()])
    field(:status, Status.t(), default: :not_started)
  end

  @doc """
  Initializes a new game of Tic-Tac-Toe.

  Requires at least one player.

  ## Examples

      iex> alias Yggdrasil.GameHub.Tictac.{Match, Player, Square}
      iex> player = Player.build("Kristoff", "X")
      iex> Match.init(player)
      %Match{
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
        players: [player],
        status: :not_started
      }

  """
  @spec init(Player.t()) :: t()
  def init(player) do
    struct(__MODULE__, %{players: [player], player_turn: nil, board: build_board()})
  end

  @doc """
  Adds a player to a match.

  - Can't add a player if the match wasn't initialized by another player.
  - Only two players are allowed in the match.

  ## Examples

      iex> alias Yggdrasil.GameHub.Tictac.{Match, Player, Square}
      iex> player_1 = Player.build("Kristoff", "X")
      iex> player_2 = Player.build("Larah", "X")
      iex> match = Match.init(player_1)
      iex> Match.join(match, player_2)
      {:ok,
        %Match{
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
          players: [
            %Player{letter: "X", name: "Kristoff"},
            %Player{letter: "O", name: "Larah"}
          ],
          status: :not_started
        }
      }
      iex> match = %Match{players: []}
      iex> Match.join(match, player_2)
      {:error, "You can only join a pre-existing match."}
      iex> match = %Match{players: [player_1, player_2]}
      iex> player_3 = Player.build("Ruth", "X")
      iex> Match.join(match, player_3)
      {:error, "Only two players are permitted."}

  """
  @spec join(t(), Player.t()) :: {:error, term()}
  def join(%__MODULE__{players: []}, _player),
    do: {:error, "You can only join a pre-existing match."}

  def join(%__MODULE__{players: [_player_1, _player_2]}, _player_3),
    do: {:error, "Only two players are permitted."}

  def join(%__MODULE__{players: [%{letter: l} = player_1]} = match, %{letter: l} = player_2) do
    player_2 = %Player{player_2 | letter: swap_letter(player_2)}
    {:ok, %__MODULE__{match | players: [player_1, player_2]}}
  end

  def join(%__MODULE__{players: [player_1]} = match, player_2) do
    {:ok, %__MODULE__{match | players: [player_1, player_2]}}
  end

  @doc """
  Begins a match if it's not already started or completed.

  ## Examples

      iex> alias Yggdrasil.GameHub.Tictac.{Match, Player}
      iex> match = %Match{status: :playing}
      iex> Match.begin(match)
      {:error, "The match is already in progress."}
      iex> match = %Match{status: :done}
      iex> Match.begin(match)
      {:error, "The match is already over."}
      iex> player_1 = Player.build("Kristoff", "X")
      iex> player_2 = Player.build("Larah", "O")
      iex> match = %Match{status: :not_started, players: [player_1, player_2]}
      iex> Match.begin(match)
      {:ok,
        %Match{
          status: :playing,
          board: nil,
          player_turn: "O",
          players: [
            %Player{letter: "X", name: "Kristoff"},
            %Player{letter: "O", name: "Larah"}
          ]
        }
      }

  """
  @spec begin(t()) :: {:error, term()} | {:ok, Match.t()}
  def begin(%__MODULE__{status: :playing}), do: {:error, "The match is already in progress."}
  def begin(%__MODULE__{status: :done}), do: {:error, "The match is already over."}

  def begin(%__MODULE__{status: :not_started, players: [_player_1, _player_2]} = match) do
    {:ok, %__MODULE__{match | status: :playing, player_turn: "O"}}
  end

  def begin(_), do: {:error, "Not enough players for the match."}

  @doc """
  Returns true if it's the player's turn.

  ## Examples

      iex> alias Yggdrasil.GameHub.Tictac.{Match, Player}
      iex> match = %Match{player_turn: "X"}
      iex> player_1 = Player.build("Kristoff", "X")
      iex> player_2 = Player.build("Larah", "O")
      iex> Match.is_player_turn?(match, player_1)
      true
      iex> Match.is_player_turn?(match, player_2)
      false

  """
  @spec is_player_turn?(t(), Player.t()) :: boolean()
  def is_player_turn?(%__MODULE__{player_turn: letter}, %Player{letter: letter}), do: true
  def is_player_turn?(_, _), do: false

  @doc """
  Returns a list of valid moves representing squares on the game board.

  This function calculates and returns a list of squares that are valid moves based on the current game state.

  ## Examples

      iex> alias Yggdrasil.GameHub.Tictac.{Match, Player}
      iex> player = Player.build("Kristoff", "X")
      iex> match = Match.init(player)
      iex> Match.get_open_squares(match)
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
    case Enum.find(@winning_combinations, &did_player_win?(game, player, &1)) do
      nil -> :not_found
      combination -> combination
    end
  end

  @doc """
  Determines if the game is over based on the current game state.

  This function checks if the game has reached its end by evaluating two conditions:

  1. Whether any player has won the game.
  2. Whether there are no open squares left on the game board.

  ## Examples

      iex> alias Yggdrasil.GameHub.Tictac.Square
      iex> alias Yggdrasil.GameHub.Tictac.Match
      iex> game = %Match{
      ...>   board: [
      ...>     %Square{letter: "X", name: :sq11},
      ...>     %Square{letter: "X", name: :sq12},
      ...>     %Square{letter: "X", name: :sq13},
      ...>     %Square{letter: nil, name: :sq21},
      ...>     %Square{letter: nil, name: :sq22},
      ...>     %Square{letter: nil, name: :sq23},
      ...>     %Square{letter: nil, name: :sq31},
      ...>     %Square{letter: nil, name: :sq32},
      ...>     %Square{letter: nil, name: :sq33}
      ...>   ],
      ...>   player_turn: nil,
      ...>   players: [
      ...>     %Player{letter: "X", name: "Larah"},
      ...>     %Player{letter: "O", name: "Kristoff"}
      ...>   ]
      ...> }
      iex> Match.game_over?(game)
      true

  """
  @spec game_over?(t()) :: boolean()
  def game_over?(game) do
    a_player_won = did_any_player_win?(game)
    no_open_squares = game |> get_open_squares() |> Enum.empty?()

    a_player_won || no_open_squares
  end

  defp build_board do
    for row <- @row_range, col <- @col_range, do: Square.build(:"sq#{row}#{col}")
  end

  defp did_player_win?(game, player, combination) do
    Enum.all?(combination, fn square ->
      has_matching_square?(game.board, square, player.letter)
    end)
  end

  defp did_any_player_win?(game) do
    Enum.any?(game.players, fn player ->
      case find_winning_combination(player, game) do
        :not_found -> false
        [_, _, _] -> true
      end
    end)
  end

  defp has_matching_square?(board, square_name, letter) do
    case Enum.find(board, &(&1.name == square_name)) do
      %Square{letter: ^letter} -> true
      _ -> false
    end
  end

  defp swap_letter(%Player{letter: "O"}), do: "X"
  defp swap_letter(_), do: "O"
end
