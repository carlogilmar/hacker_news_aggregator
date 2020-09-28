defmodule HackerNewsAggregator.StoryClient do
  use GenServer

  def start_link(state \\ []) do
    GenServer.start_link(__MODULE__, state, name: __MODULE__)
  end

  @impl true
  def init(_opts) do
    {:ok, %{status: :not_initialized, last_updated: nil, ids: [], stories: %{} }}
  end

  @spec get_story(String.t()) :: struct() | nil
  def get_story(story_id) do
    GenServer.call(__MODULE__, {:get_story, story_id})
  end

  @impl true
  def handle_call({:get_story, story_id}, _from, state) do
    story = state.stories[story_id]
    {:reply, story, state}
  end
end
