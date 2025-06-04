defmodule FinanceControl.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      FinanceControlWeb.Telemetry,
      FinanceControl.Repo,
      {DNSCluster, query: Application.get_env(:finance_control, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: FinanceControl.PubSub},
      # Start a worker by calling: FinanceControl.Worker.start_link(arg)
      # {FinanceControl.Worker, arg},
      # Start to serve requests, typically the last entry
      FinanceControlWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: FinanceControl.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    FinanceControlWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
