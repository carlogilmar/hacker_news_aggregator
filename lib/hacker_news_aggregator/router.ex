defmodule HackerNewsAggregator.Router do
  @moduledoc "This module is for implement the api endpoints"
  use Plug.Router
  plug(:match)
  plug(:dispatch)

  get "/story" do
    send_resp(conn, 404, "404")
  end

  get "/story/:id" do
    ["story", story_id] = conn.path_info
    {status_code, response} = HackerNewsAggregator.get_story_by_id(story_id)
    conn = %{conn | resp_headers: [{"content-type", "application/json"}]}
    send_resp(conn, status_code, Poison.encode!(response))
  end

  get "/stories" do
    page =
      if conn.query_params == %{} do
        "0"
      else
        %{"page" => page_number} = conn.query_params
        page_number
      end

    {status_code, response} = HackerNewsAggregator.get_stories(page)
    conn = %{conn | resp_headers: [{"content-type", "application/json"}]}
    send_resp(conn, status_code, Poison.encode!(response))
  end

  match _ do
    send_resp(conn, 404, "404")
  end
end
