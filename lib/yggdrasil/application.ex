defmodule Yggdrasil.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  require Logger

  use Application

  @impl true
  def start(_type, _args) do
    env = get_app_env()

    children = [
      # Start the Telemetry supervisor
      YggdrasilWeb.Telemetry,
      # Start the Ecto repository
      Yggdrasil.Repo,
      # Start the PubSub system
      {Phoenix.PubSub, name: Yggdrasil.PubSub},
      # Setup for clustering
      {Cluster.Supervisor, [libcluster(env), [name: Yggdrasil.ClusterSupervisor]]},
      # Start Finch
      {Finch, name: Yggdrasil.Finch},
      # Start the Endpoint (http/https)
      YggdrasilWeb.Endpoint
      # Start a worker by calling: Yggdrasil.Worker.start_link(arg)
      # {Yggdrasil.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Yggdrasil.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    YggdrasilWeb.Endpoint.config_change(changed, removed)
    :ok
  end

  defp get_app_env, do: Application.get_env(:yggdrasil, :env)

  defp libcluster(:prod) do
    Logger.info("Using libcluster(:prod) mode. DNSPoll strategy.")

    app_name = System.get_env("APP_NAME") || raise "APP_NAME not available."

    [
      topologies: [
        fly6pn: [
          strategy: Cluster.Strategy.DNSPoll,
          config: [
            polling_interval: 5_000,
            query: "#{app_name}.internal",
            node_basename: app_name
          ]
        ]
      ]
    ]
  end

  defp libcluster(:test), do: []

  defp libcluster(other) do
    Logger.info("Using libcluster(_) mode with #{inspect(other)}. Epmd strategy.")

    [
      topologies: [
        strategy: Cluster.Strategy.Epmd,
        config: [hosts: [:"a@127.0.0.1", :"b@127.0.0.1"]]
      ]
    ]
  end
end
