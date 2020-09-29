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
    {_ids, stories} = lookup_top_50()
    story = stories[story_id]
    {:reply, story, state}
  end

  @impl true
  def handle_call({:get_top_50}, _from, state) do
    {ids, stories} = lookup_top_50()
    top_50 = Enum.into(ids, [], fn id -> stories["#{id}"] end)
    {:reply, top_50, state}
  end

  @impl true
  def handle_call({:get_stories, page}, _from, state) do
    {ids, stories} = lookup_top_50()

    index =
      case page do
        page when page in 2..5 -> page * 10 - 10
        1 -> 0
        _other -> 50
      end

    stories_chunk =
      ids
      |> Enum.slice(index, 10)
      |> Enum.into([], fn id -> stories["#{id}"] end)

    {:reply, stories_chunk, state}
  end

  @impl true
  def handle_cast({:fetch_stories}, state) do
    %{ids: ids, stories: stories} = HackerNewsClient.get_stories()
    insert_top_50(ids, stories)
    {:noreply, state}
  end

  @impl true
  def handle_info(:scheduler, state) do
    Logger.debug("Fetching top 50")
    fetch_top_50()
    execute_scheduler()
    {:noreply, state}
  end

  defp execute_scheduler do
    Process.send_after(self(), :scheduler, 60_000)
  end

  defp create_ets_tables do
    :ets.new(:top_50_ids, [:set, :private, :named_table])
    :ets.new(:stories, [:set, :private, :named_table])
  end

  defp insert_top_50(ids, stories) do
    :ets.insert(:top_50_ids, {@ets_key, ids})
    :ets.insert(:stories, {@ets_key, stories})
  end

  defp lookup_top_50 do
    [{@ets_key, ids}] = :ets.lookup(:top_50_ids, @ets_key)
    [{@ets_key, stories}] = :ets.lookup(:stories, @ets_key)
    {ids, stories}
  end
end
