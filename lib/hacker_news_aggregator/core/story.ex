defmodule HackerNewsAggregator.Story do
  @moduledoc "This module is for implement the story struct"
  defstruct [:id, :by, :descendants, :kids, :score, :time, :title, :type, :url]

  @spec new(map()) :: %__MODULE__{}
  def new(params) when is_map(params) do
    %__MODULE__{
      id: params["id"],
      by: params["by"],
      descendants: params["descendants"],
      kids: params["kids"],
      score: params["score"],
      time: params["time"],
      title: params["title"],
      type: params["type"],
      url: params["url"]
    }
  end
end
