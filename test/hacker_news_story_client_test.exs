defmodule HackerNewsAggregatorTest do
  use ExUnit.Case
  alias HackerNewsAggregator.StoryClient

  setup do
    start_supervised(StoryClient)
    :ok
  end

  test "Fetch story detail when the client isn't initialized" do
    [1, "2", 0, "6534"]
    |> Enum.into([], fn id -> StoryClient.get_story(id) end)
    |> Enum.each(fn story ->
      assert story == nil
    end)
  end

  test "Fetch and get top 50 stories" do
    top_50_before_fetch = StoryClient.get_top_50()
    StoryClient.fetch_top_50()
    top_50_after_fetch = StoryClient.get_top_50()
    assert length(top_50_before_fetch) == 0
    assert length(top_50_after_fetch) == 50

    Enum.each(top_50_after_fetch, fn story ->
      assert is_struct(story)
    end)
  end

  test "Get story detail after fetch data" do
    StoryClient.fetch_top_50()

    1..25
    |> Enum.into([], fn index -> 24_591_952 + index end)
    |> Enum.each(fn story_fake_id ->
      story = StoryClient.get_story("#{story_fake_id}")
      assert is_struct(story)
      assert !is_nil(story)
    end)
  end

  test "Get stories by pagination" do
    pages = [{1,10}, {2, 10}, {3, 10}, {4, 10}, {5, 10}, {0,0}, {6, 0}, {7, 0}]
    Enum.each(pages,
      fn {page, stories_size_expected} ->
        stories = StoryClient.get_stories(page)
        assert length(stories) == stories_size_expected
      end)
  end
end
