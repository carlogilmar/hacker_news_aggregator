defmodule HackerNewsAggregatorTest.HackerNewsClientTest do
  use ExUnit.Case
  alias HackerNewsAggregator.HackerNewsClient

  test "Getting top 50 ids from API" do
    top_50_ids = HackerNewsClient.get_top_50_ids()
    assert length(top_50_ids) == 50
  end

  test "Get story detail" do
    story = HackerNewsClient.get_story_detail(1)
    assert is_struct(story)
  end

  test "Get a map with the ids and the storie's detail" do
    %{ids: ids, stories: stories} = HackerNewsClient.get_stories()
    assert length(ids) == 50

    Enum.each(stories, fn {_k, v} ->
      assert is_struct(v)
    end)
  end
end
