defmodule MasEnvServer.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      MasEnvServerWeb.Telemetry,
      MasEnvServer.Repo,
      {DNSCluster, query: Application.get_env(:mas_env_server, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: MasEnvServer.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: MasEnvServer.Finch},
      # Start a worker by calling: MasEnvServer.Worker.start_link(arg)
      # {MasEnvServer.Worker, arg},
      # Start to serve requests, typically the last entry
      MasEnvServerWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: MasEnvServer.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    MasEnvServerWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
