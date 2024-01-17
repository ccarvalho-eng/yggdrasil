defmodule YggdrasilWeb.GameController do
  @moduledoc false

  use YggdrasilWeb, :controller

  @doc false
  @spec join(Plug.Conn.t(), map()) :: Plug.Conn.t()
  def join(conn, %{"slug" => "tic-tac-toe"}) do
    render(conn, :tic_tac)
  end

  def join(conn, _) do
    render(conn, :not_found)
  end
end
