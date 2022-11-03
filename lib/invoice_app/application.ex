defmodule InvoiceApp.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Start the Ecto repository
      InvoiceApp.Repo,
      # Start the Telemetry supervisor
      InvoiceAppWeb.Telemetry,
      # Start the PubSub system
      {Phoenix.PubSub, name: InvoiceApp.PubSub},
      # Start the Endpoint (http/https)
      InvoiceAppWeb.Endpoint
      # Start a worker by calling: InvoiceApp.Worker.start_link(arg)
      # {InvoiceApp.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: InvoiceApp.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    InvoiceAppWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
