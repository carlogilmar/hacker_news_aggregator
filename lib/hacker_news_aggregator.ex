defmodule HackerNewsAggregator do
  @moduledoc """
    This module is for provide a general way to interact to the core functionality
    - Get a story by id
    - Get a chunk of stories
  """
  alias HackerNewsAggregator.StoryClient

  @doc "Function to get a story by id"
  @spec get_story_by_id(String.t()) :: struct()
  def get_story_by_id(story_id) do
    StoryClient.get_story(story_id)
  end

  @doc "Function for get a chunk of paginated stories"
  @spec get_stories(integer()) :: list()
  def get_stories(page) do
    StoryClient.get_stories(page)
  end
end
