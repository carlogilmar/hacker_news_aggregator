defmodule HackerNewsAggregatorTest.StoryTest do
  use ExUnit.Case
  alias HackerNewsAggregator.Story

  test "Get a story struct from a map" do
    maps_to_transform = [
      get_story_with_more_keys_not_mapped(),
      get_story_with_keys_not_mapped(),
      get_story_with_less_keys_mapped()
    ]

    Enum.each(maps_to_transform, fn map ->
      story = Story.new(map)
      assert is_struct(story)
    end)
  end

  defp get_story_with_more_keys_not_mapped do
    %{
      "by" => "pg",
      "descendants" => 54,
      "id" => 1,
      "kids" => [126_822, 126_823],
      "parts" => [126_810, 126_811, 126_812],
      "score" => 47,
      "time" => 1_204_403_652,
      "title" => "Poll: What would happen if News.YC had explicit support for polls?",
      "type" => "poll",
      "fake" => "heeey",
      "fake field" => "I'm fake and this won't break this"
    }
  end

  defp get_story_with_keys_not_mapped do
    %{
      "by" => "pg",
      "descendants" => 54,
      "id" => 1,
      "kids" => [126_822, 126_823],
      "parts" => [126_810, 126_811, 126_812],
      "score" => 47,
      "time" => 1_204_403_652,
      "title" => "Poll: What would happen if News.YC had explicit support for polls?",
      "type" => "poll",
      "url" => "http://"
    }
  end

  defp get_story_with_less_keys_mapped do
    %{
      "descendants" => 54,
      "id" => 1,
      "score" => 47,
      "title" => "Poll: What would happen if News.YC had explicit support for polls?"
    }
  end
end
