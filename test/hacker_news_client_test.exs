defmodule HackerNewsAggregatorTest.HackerNewsClientTest do
  use ExUnit.Case
  alias HackerNewsAggregator.HackerNewsClient

  test "Getting top 50 ids from API" do
    top_50_ids = HackerNewsClient.get_top_ids()
    assert length(top_50_ids) == 50
  end

  test "Get story detail" do
    story = HackerNewsClient.get_story_detail(1)
    assert is_struct(story)
  end

  test "Get a map with the top50 and the storie's detail" do
    %{top_50: top_50, stories: stories} = HackerNewsClient.get_stories()

    assert !Enum.empty?(top_50)

    Enum.each(top_50, fn story ->
      assert is_struct(story)
    end)

    Enum.each(stories, fn {_k, v} ->
      assert is_struct(v)
    end)
  end
end
