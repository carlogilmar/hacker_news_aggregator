defmodule HackerNewsAggregator.StoryClient do
  @moduledoc "This module is a genserver to manage the Stories Top 50 data"
  use GenServer
  alias HackerNewsAggregator.HackerNewsClient
  require Logger
  @ets_key "top_50"

  def start_link(state \\ []) do
    GenServer.start_link(__MODULE__, state, name: __MODULE__)
  end

  @doc """
    This function will make the setup:
      - Create ETS tables to store the top50 data
      - Execute the scheduler to refresh the data
      - Will fetch the top50 data to initialize

    If this GenServer dies, the supervisor will restone it, and this module will make this setup again with fesh data
  """
  @impl true
  def init(_opts) do
    execute_scheduler()
    create_ets_tables()
    fetch_top_50()
    {:ok, %{msg: :client_initialized}}
  end

  @doc "This function will refresh the top50 stories"
  @spec fetch_top_50() :: :ok
  def fetch_top_50 do
    GenServer.cast(__MODULE__, {:fetch_stories})
  end

  @doc """
    This function is for get the story detail from an story id
    iex> get_story("24620491")
  """
  @spec get_story(String.t()) :: struct() | nil
  def get_story(story_id) do
    GenServer.call(__MODULE__, {:get_story, story_id})
  end

  @doc "This function is for get the top50, this is a list of stories"
  @spec get_top_50() :: list()
  def get_top_50 do
    GenServer.call(__MODULE__, {:get_top_50})
  end

  @doc "This function is for get a chunk of paginated stories list"
  @spec get_stories(integer()) :: list()
  def get_stories(page) when is_integer(page) do
    GenServer.call(__MODULE__, {:get_stories, page})
  end

  @impl true
  def handle_call({:get_story, story_id}, _from, state) do
    {_top_50, stories} = lookup_top_50()
    story = stories[story_id]
    {:reply, story, state}
  end

  @impl true
  def handle_call({:get_top_50}, _from, state) do
    {top_50, _stories} = lookup_top_50()
    {:reply, top_50, state}
  end

  @impl true
  def handle_call({:get_stories, page}, _from, state) do
    {top_50, _stories} = lookup_top_50()
    index = page * 10 - 10
    stories_chunk = Enum.slice(top_50, index, 10)
    {:reply, stories_chunk, state}
  end

  @impl true
  def handle_cast({:fetch_stories}, state) do
    %{top_50: top_50, stories: stories} = HackerNewsClient.get_stories()
    insert_top_50(top_50, stories)
    {:noreply, state}
  end

  @impl true
  def handle_info(:scheduler, state) do
    Logger.debug("Fetching top 50 and refresh websockets")
    fetch_top_50()
    {top_50, _stories} = lookup_top_50()
    HackerNewsAggregator.refresh_websockets(top_50)
    execute_scheduler()
    {:noreply, state}
  end

  defp execute_scheduler do
    Process.send_after(self(), :scheduler, 300_000)
  end

  defp create_ets_tables do
    :ets.new(:top_50, [:set, :private, :named_table])
    :ets.new(:stories, [:set, :private, :named_table])
  end

  defp insert_top_50(top_50, stories) do
    :ets.insert(:top_50, {@ets_key, top_50})
    :ets.insert(:stories, {@ets_key, stories})
  end

  defp lookup_top_50 do
    [{@ets_key, stories}] = :ets.lookup(:stories, @ets_key)
    [{@ets_key, top_50}] = :ets.lookup(:top_50, @ets_key)
    {top_50, stories}
  end
end
