defmodule HackerNewsAggregator.Endpoint do
  @moduledoc "This module is for implement the Endpoint"
  use Plug.Router

  plug(:match)
  plug(Plug.Parsers, parsers: [:json], pass: ["application/json"], json_decoder: Poison)
  plug(:dispatch)

  def child_spec(opts) do
    %{
      id: __MODULE__,
      start: {__MODULE__, :start_link, [opts]}
    }
  end

  def start_link(_opts) do
    Plug.Cowboy.http(__MODULE__, [])
  end

  forward("/api/v1/", to: HackerNewsAggregator.Router)
end
