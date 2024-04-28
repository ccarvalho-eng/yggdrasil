defmodule Yggdrasil.GameServer do
  @moduledoc """
  A GenServer for handling and modeling a game state.
  """

  use GenServer

  require Logger

  alias __MODULE__
  alias Yggdrasil.GameHub.Tictac.Player, as: TicTacPlayer

  @type player :: TicTactPlayer

  # Client

  @doc """
  GameServer specifications.
  """
  @spec child_spec(keyword()) :: map()
  def child_spec(opts) do
    name = Keyword.get(opts, :name, __MODULE__)
    player = Keyword.fetch!(opts, :player)

    %{
      id: "#{__MODULE__}_#{name}",
      start: {__MODULE__, :start_link, [name, player]},
      shutdown: 10_000,
      restart: :transient
    }
  end

  @doc """
  Starts GameServer with the specified code as the name.
  """
  @spec start_link(code :: String.t(), player()) :: :ignore | {:ok, pid()}
  def start_link(code, player) do
    case GenServer.start_link(__MODULE__, %{code: code, player: player},
           name: build_server_name(code)
         ) do
      {:ok, pid} ->
        {:ok, pid}

      {:error, {:already_started, pid}} ->
        Logger.info("#{__MODULE__} already running at #{pid}. Ignoring ...")

        :ignore
    end
  end

  @doc """
  Starts a new or ongoing match.
  """
  @spec start_or_join(code :: String.t(), player()) :: {:ok, :started}
  def start_or_join(code, player) do
    case Horde.DynamicSupervisor.start_child(
           Tictac.DistributedSupervisor,
           {__MODULE__, [name: code, player: player]}
         ) do
      {:ok, _pid} ->
        Logger.info("#{__MODULE__} started")
        {:ok, :started}

      :ignore ->
        Logger.info("#{__MODULE__} already running. Joining ...")

        case join_match(code, player) do
          :ok ->
            {:ok, :joined}

          {:error, _reason} = error ->
            error
        end
    end
  end

  @doc """
  Joins an ongoing match.
  """
  @spec join_match(code :: String.t(), player()) :: :ok | {:error, String.t()}
  def join_match(code, player) do
    code |> build_server_name() |> GenServer.call({:join_game, player})
  end

  @doc """
  Performs a move for the player.
  """
  @spec move(code :: String.t(), player_id :: String.t(), square :: atom()) ::
          :ok | {:error, String.t()}
  def move(code, player_id, square) do
    code |> build_server_name() |> GenServer.call({:move, player_id, square})
  end

  @doc """
  Returns the current match state.
  """
  @spec get_current_match_state(code :: String.t()) :: :ok | {:error, String.t()}
  def get_current_match_state(code) do
    code |> build_server_name() |> GenServer.call(:current_state)
  end

  @doc """
  Resets the current match keeping the same players.
  """
  @spec restart(code :: String.t()) :: :ok | {:error, String.t()}
  def restart(code) do
    code |> build_server_name() |> GenServer.call(:restart)
  end

  # Server (callbacks)

  defp build_server_name(code) do
    {:via, Horde.Registry, {Tictac.GameRegistry, code}}
  end
end
