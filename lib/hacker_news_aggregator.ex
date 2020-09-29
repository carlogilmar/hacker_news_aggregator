defmodule HackerNewsAggregator do
  @moduledoc """
    This module is for provide a general way to interact from the API to the core functionality
    - Get a story by id
    - Get a chunk of stories
  """
  alias HackerNewsAggregator.StoryClient
  alias HackerNewsAggregator.Websocket

  @doc "Function to get a story by id"
  @spec get_story_by_id(String.t()) :: {200, struct()} | {404, map()}
  def get_story_by_id(story_id) when is_binary(story_id) do
    story_id
    |> StoryClient.get_story()
    |> handle_response()
  end

  @doc "Function for get a chunk of paginated stories"
  @spec get_stories(String.t()) :: {200, list()} | {404, map()}
  def get_stories(page) when is_binary(page) do
    page
    |> String.to_integer()
    |> StoryClient.get_stories()
    |> handle_response()
  end

  @doc "I implemented this function for isolate the core functionality from the web components"
  @spec refresh_websockets(list()) :: :ok
  def refresh_websockets(top_50) do
    Websocket.send_broadcast(top_50)
  end

  defp handle_response(resource) do
    case resource do
      nil ->
        {404, %{msg: "Resource not found"}}

      [] ->
        {404, %{msg: "Resource not found"}}

      resource ->
        {200, resource}
    end
  end
end
