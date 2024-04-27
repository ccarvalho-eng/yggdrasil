defmodule Yggdrasil.GameServer do
  @moduledoc """
  A GenServer for handling and modeling a game state.
  """

  use GenServer

  alias __MODULE__
  alias Yggdrasil.GameHub.Tictac.Player

  def child_spec(opts) do
    name = Keyword.get(opts, :name, GameServer)
    player = Keyword.fetch!(opts, :player)

    %{
      id: "#{GameServer}_#{name}",
      start: {GameServer, :start_link, [name, player]},
      shutdown: 10_000,
      restart: :transient
    }
  end

  def start_link(code, %Player{} = player) do
    case GenServer.start_link(GameServer, %{player: player, code: code},
           name: build_server_name(code)
         ) do
      {:ok, pid} ->
        {:ok, pid}

      {:error, {:already_started, pid}} ->
        :ignore
    end
  end

  defp build_server_name(code) do
    {:via, Horde.Registry, {Tictac.GameRegistry, code}}
  end
end
