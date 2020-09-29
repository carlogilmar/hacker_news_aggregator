defmodule HackerNewsAggregator.Websocket do
  @behaviour :cowboy_websocket

  @impl true
  def init(request, _state) do
    state = %{registry_key: request.path}
    {:cowboy_websocket, request, state}
  end

  @impl true
  def websocket_init(state) do
    Registry.HackerNewsAggregator
    |> Registry.register(state.registry_key, {})
    {:ok, state}
  end

  @impl true
  def websocket_info(info, state) do
    {:reply, {:text, info}, state}
  end

  @impl true
  def websocket_handle({:text, message}, state) do
    {:reply, {:text, "Heeey!"}, state}
  end

  def send_broadcast(message) do
    response_encoded = Poison.encode!(%{body: message})

    Registry.dispatch(Registry.HackerNewsAggregator, "/ws/top50",
      fn entries ->
        Enum.each(entries, fn {pid, _} ->
          Process.send(pid, response_encoded, [])
        end)
      end)
  end
end
