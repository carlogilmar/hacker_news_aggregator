defmodule HttpClientMock do
  @moduledoc "This module it's for support testing and provide mock responses"

  @spec get(String.t()) :: list()
  @doc "This function will provide fake data"
  def get(url) do
    case url do
      "https://hacker-news.firebaseio.com/v0/topstories.json" ->
        fake_ids = Enum.into(1..50, [], fn x -> 24_591_952 + x end)
        {:ok, fake_ids}

      story_url_detail ->
        <<_url_path::8*43, story_id::binary>> = story_url_detail
        [id, _] = String.split(story_id, ".json")
        {:ok, get_story_detail(id)}
    end
  end

  defp get_story_detail(id) do
    %{
      "by" => "pg",
      "descendants" => 54,
      "id" => id,
      "kids" => [126_822, 126_823],
      "parts" => [126_810, 126_811, 126_812],
      "score" => 47,
      "time" => 1_204_403_652,
      "title" => "Poll: What would happen if News.YC had explicit support for polls?",
      "type" => "poll"
    }
  end
end
