defmodule HackerNewsAggregator.HackerNewsClient do
  @moduledoc "This module is for fetch data from Hacker News Api"
  alias HackerNewsAggregator.Story

  @http_client Application.get_env(
                 :hacker_news_aggregator,
                 :http_client,
                 HackerNewsAggregator.HttpPoisonClient
               )

  @doc """
    This function is for get the top stories ids from the HackerNews Endpoint
    By default was set with off_set 0 and size 50 for get the first 50th elements
  """
  @spec get_top_ids() :: list()
  def get_top_ids(off_set \\ 0, size \\ 50) do
    get_hacker_news_top_50_endpoint()
    |> @http_client.get()
    |> handle_response(off_set, size)
  end

  defp handle_response({:ok, top_ids}, off_set, size) do
    Enum.slice(top_ids, off_set, size)
  end

  defp handle_response({:error, _error}, _off_set, _size) do
    []
  end

  @spec get_story_detail(integer()) :: %Story{}
  def get_story_detail(story_id) do
    endpoint = get_hacker_news_story_endpoint(story_id)
    {:ok, story_detail} = @http_client.get(endpoint)
    Story.new(story_detail)
  end

  @spec get_stories() :: %{ids: list(), stories: map()}
  def get_stories do
    ids = get_top_ids()

    stories =
      Task.async_stream(ids, fn id -> get_story_detail(id) end)
      |> Enum.to_list()
      |> Map.new(fn {:ok, story} -> {"#{story.id}", story} end)

    %{ids: ids, stories: stories}
  end

  defp get_hacker_news_api do
    Application.get_env(:hacker_news_aggregator, :api)
  end

  defp get_hacker_news_top_50_endpoint do
    "#{get_hacker_news_api()}" <> "/topstories.json"
  end

  defp get_hacker_news_story_endpoint(story_id) do
    "#{get_hacker_news_api()}" <> "/item/#{story_id}.json"
  end
end
