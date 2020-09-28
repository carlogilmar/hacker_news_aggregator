defmodule HackerNewsAggregator.HttpClient do
  @moduledoc "This module is for make Http requests and decode the response body"

  @spec get(String.t()) :: map()
  def get(api_endpoint) when is_binary(api_endpoint) do
    with {:ok, response} <- HTTPoison.get(api_endpoint) do
      Poison.decode(response.body)
    else
      {:error, error_response} ->
        {:error, error_response.reason}
    end
  end
end
