defmodule HackerNewsAggregator.HackerNewsClient do
  @moduledoc "This module is for fetch data from Hacker News Api"
  @api_endpoint Application.get_env(:hacker_news_aggregator, :api)
  @http_client Application.get_env(:hacker_news_aggregator, :http_client, HackerNewsAggregator.HttpClient)

  @spec get_top_50_ids() :: list()
  def get_top_50_ids do
    with {:ok, top_ids} <- @http_client.get("#{@api_endpoint}/topstories.json") do
      Enum.take(top_ids, 50)
    else
      _error -> []
    end
  end

end
