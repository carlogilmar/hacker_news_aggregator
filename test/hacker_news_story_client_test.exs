defmodule HackerNewsAggregatorTest do
  use ExUnit.Case
  alias HackerNewsAggregator.StoryClient

  setup do
    start_supervised(StoryClient)
    :ok
  end

  test "Fetch story detail when the client isn't initialized" do
    [1,"2",0, "6534"]
    |> Enum.into([], fn id -> StoryClient.get_story(id) end)
    |> Enum.each(fn story ->
      assert story == nil
    end)

  end
end
