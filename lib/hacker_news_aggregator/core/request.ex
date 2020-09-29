defmodule HackerNewsAggregator.Request do
  @moduledoc "This module is the behaviour for define the HttpClient functions to be implemented"

  @callback get(endpoint :: String.t()) :: {:ok, map()} | {:error, atom()}
end
