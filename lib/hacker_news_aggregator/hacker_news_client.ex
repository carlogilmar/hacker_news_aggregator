defmodule HackerNewsAggregator.HackerNewsClient do
  @moduledoc "This module is for fetch data from Hacker News Api"
  @api_endpoint Application.get_env(:hacker_news_aggregator, :api)
  @http_client Application.get_env(:hacker_news_aggregator, :http_client, HackerNewsAggregator.HttpClient)

  @spec get_top_50_ids() :: list()
  def get_top_50_ids do
    case @http_client.get("#{@api_endpoint}/topstories.json") do
      {:ok, top_ids} -> Enum.take(top_ids, 50)
      _error -> []
    end
  end

end
