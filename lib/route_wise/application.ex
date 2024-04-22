defmodule RouteWise.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      RouteWiseWeb.Telemetry,
      RouteWise.Repo,
      {DNSCluster, query: Application.get_env(:route_wise, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: RouteWise.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: RouteWise.Finch},
      # Start a worker by calling: RouteWise.Worker.start_link(arg)
      # {RouteWise.Worker, arg},
      # Start to serve requests, typically the last entry
      RouteWiseWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: RouteWise.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    RouteWiseWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
