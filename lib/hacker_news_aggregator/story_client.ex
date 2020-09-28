defmodule HackerNewsAggregator.StoryClient do
  @moduledoc "This module is a genserver to manage the Stories Top 50 data"
  use GenServer
  alias HackerNewsAggregator.HackerNewsClient

  def start_link(state \\ []) do
    GenServer.start_link(__MODULE__, state, name: __MODULE__)
  end

  @impl true
  def init(_opts) do
    {:ok, %{ids: [], stories: %{}}}
  end

  @spec get_story(String.t()) :: struct() | nil
  def get_story(story_id) do
    GenServer.call(__MODULE__, {:get_story, story_id})
  end

  @spec get_top_50() :: list
  def get_top_50 do
    GenServer.call(__MODULE__, {:get_top_50})
  end

  @spec fetch_top_50() :: :ok
  def fetch_top_50 do
    GenServer.cast(__MODULE__, {:fetch_stories})
  end

  @spec get_stories(integer()) :: list()
  def get_stories(page) when is_integer(page) do
    GenServer.call(__MODULE__, {:get_stories, page})
  end

  @impl true
  def handle_call({:get_story, story_id}, _from, state) do
    story = state.stories[story_id]
    {:reply, story, state}
  end

  @impl true
  def handle_call({:get_top_50}, _from, state) do
    top_50 = Enum.into(state.ids, [], fn id -> state.stories["#{id}"] end)
    {:reply, top_50, state}
  end

  @impl true
  def handle_call({:get_stories, page}, _from, state) do
    index =
      case page do
        page when page in 2..5 -> (page*10)-10
          1 -> 0
          _other -> 50
      end

    stories_chunk =
      state.ids
      |> Enum.slice(index, 10)
      |> Enum.into([], fn id -> state.stories["#{id}"] end)

    {:reply, stories_chunk, state}
  end

  @impl true
  def handle_cast({:fetch_stories}, state) do
    %{ids: ids, stories: stories} = HackerNewsClient.get_stories()
    state_updated = %{state | ids: ids, stories: stories}
    {:noreply, state_updated}
  end

end
