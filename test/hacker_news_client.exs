defmodule HackerNewsAggregatorTest.HackerNewsClient do
  use ExUnit.Case
  alias HackerNewsAggregator.HackerNewsClient

  test "Getting top 50 ids from API" do
    top_50_ids = HackerNewsClient.get_top_50_ids()
    assert length(top_50_ids) == 50
  end

  test "Get item detail" do
    story = HackerNewsClient.get_story_detail(1)
    assert is_struct(story)
  end
end
