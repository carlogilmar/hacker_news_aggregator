defmodule HackerNewsAggregator.Router do
  @moduledoc "This module is for implement the api endpoints"
  use Plug.Router
  plug(:match)
  plug(:dispatch)

  get "/story/:id" do
    ["story", story_id] = conn.path_info
    {status_code, response} = HackerNewsAggregator.get_story_by_id(story_id)
    conn = %{conn | resp_headers: [{"content-type", "application/json"}]}
    send_resp(conn, status_code, Poison.encode!(response))
  end

  get "/stories" do
    %{"page" => page} = conn.query_params
    {status_code, response} = HackerNewsAggregator.get_stories(page)
    conn = %{conn | resp_headers: [{"content-type", "application/json"}]}
    send_resp(conn, status_code, Poison.encode!(response))
  end
end
