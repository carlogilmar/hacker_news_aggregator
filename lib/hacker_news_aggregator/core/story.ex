defmodule HackerNewsAggregator.Story do
  @moduledoc "This module is for implement the story struct"
  defstruct [:id, :by, :descendants, :kids, :score, :time, :title, :type, :url]

  @spec new(map()) :: %__MODULE__{}
  def new(params) when is_map(params) do
    story = Map.new(params, fn {k, v} -> {String.to_existing_atom(k), v} end)
    struct(%__MODULE__{}, story)
  end
end
