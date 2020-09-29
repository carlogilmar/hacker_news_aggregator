defmodule HackerNewsAggregator.HttpClient do
  @moduledoc "This module is for make Http requests and decode the response body"

  @spec get(String.t()) :: {:ok, map()} | {:error, atom()}
  def get(api_endpoint) when is_binary(api_endpoint) do
    case HTTPoison.get(api_endpoint) do
      {:ok, response} -> Poison.decode(response.body)
      {:error, error_response} -> {:error, error_response.reason}
    end
  end
end
