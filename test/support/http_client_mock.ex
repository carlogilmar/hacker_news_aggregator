defmodule HttpClientMock do
  @moduledoc "This module it's for support testing and provide mock responses"

  @spec get(String.t()) :: list()
  @doc "This function will provide fake data"
  def get(url) do
    case url do
      "https://hacker-news.firebaseio.com/v0/topstories.json" ->
        {:ok, Enum.to_list(1..100)}
    end
  end
end
