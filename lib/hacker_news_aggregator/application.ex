defmodule HackerNewsAggregator.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    children = [
      # Starts a worker by calling: HackerNewsAggregator.Worker.start_link(arg)
      # {HackerNewsAggregator.Worker, arg}
      HackerNewsAggregator.StoryClient,
      HackerNewsAggregator.Endpoint,
      Plug.Cowboy.child_spec(
        scheme: :http,
        plug: HackerNewsAggregator.Router,
        options: [dispatch: dispatch(), port: 4001]),
      Registry.child_spec(keys: :duplicate, name: Registry.HackerNewsAggregator)
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: HackerNewsAggregator.Supervisor]
    Supervisor.start_link(children, opts)
  end

  defp dispatch do
    [
      {:_,
        [
          {"/ws/top50", HackerNewsAggregator.Websocket, []},
          {:_, Plug.Cowboy.Handler, {HackerNewsAggregator.Router, []}}
        ]
      }
    ]
  end

end
