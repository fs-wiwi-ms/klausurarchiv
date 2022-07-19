defmodule Klausurarchiv.Application do
  use Application

  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  def start(_type, _args) do
    # Define workers and child supervisors to be supervised
    children = [
      # Start the PubSub system
      {Phoenix.PubSub, name: Klausurarchiv.PubSub},
      # Start the Ecto repository
      Klausurarchiv.Repo,
      # Start the endpoint when the application starts
      KlausurarchivWeb.Endpoint,
      # Start cron-like service that runs tasks
      Klausurarchiv.Scheduler
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Klausurarchiv.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    KlausurarchivWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
