defmodule HttpClientMock do
  @moduledoc "This module it's for support testing and provide mock responses"

  @spec get(String.t()) :: list()
  @doc "This function will provide fake data"
  def get(url) do
    case url do
      "https://hacker-news.firebaseio.com/v0/topstories.json" ->
        {:ok, Enum.to_list(1..100)}

      _story_detail_endpoint ->
        {:ok, get_story_detail()}
    end
  end

  defp get_story_detail do
    %{
      "by" => "pg",
      "descendants" => 54,
      "id" => 126_809,
      "kids" => [126_822, 126_823],
      "parts" => [126_810, 126_811, 126_812],
      "score" => 47,
      "time" => 1_204_403_652,
      "title" => "Poll: What would happen if News.YC had explicit support for polls?",
      "type" => "poll"
    }
  end
end
