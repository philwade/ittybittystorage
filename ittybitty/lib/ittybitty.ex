defmodule Ittybitty do
  use Application

  # See http://elixir-lang.org/docs/stable/elixir/Application.html
  # for more information on OTP Applications
  def start(_type, _args) do
    import Supervisor.Spec

    redis_uri = Application.fetch_env!(:ittybitty, :redis_uri)

    # Define workers and child supervisors to be supervised
    children = [
      # Start the Ecto repository
      supervisor(Ittybitty.Repo, []),
      # Start the endpoint when the application starts
      supervisor(Ittybitty.Endpoint, []),
      # Start your own worker by calling: Ittybitty.Worker.start_link(arg1, arg2, arg3)
      # worker(Ittybitty.Worker, [arg1, arg2, arg3]),
      worker(Redix, [redis_uri, [name: :redix]]),
      worker(Task.Supervisor, [[name: Ittybitty.DbSupervisor]]),
    ]

    # See http://elixir-lang.org/docs/stable/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Ittybitty.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    Ittybitty.Endpoint.config_change(changed, removed)
    :ok
  end
end
