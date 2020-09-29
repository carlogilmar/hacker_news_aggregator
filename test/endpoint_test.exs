defmodule HackerNewsAggregatorTest.EndpointTest do
  use ExUnit.Case
  use Plug.Test
  alias HackerNewsAggregator.StoryClient
  alias HackerNewsAggregator.Endpoint
  alias HackerNewsAggregator.Router

  setup do
    start_supervised(StoryClient)
    start_supervised(Endpoint)
    :ok
  end

  describe "Test the api scenarios" do
    test "Get a story with a wrong id" do
      conn = conn(:get, "/story/1")
      conn = %{conn | host: "localhost:400/api/v1"}
      conn = Router.call(conn, [])
      assert conn.status == 404
    end

    test "Get a story with a good id" do
      conn = conn(:get, "/story/24591953")
      conn = %{conn | host: "localhost:400/api/v1"}
      conn = Router.call(conn, [])
      assert conn.status == 200
    end

    test "Get a chunk of stories per pages allowed" do
      Enum.each([1, 2, 3, 4, 5], fn page ->
        conn = conn(:get, "/stories")
        conn = %{conn | host: "localhost:400/api/v1", query_params: %{"page" => "#{page}"}}
        conn = Router.call(conn, [])
        assert conn.status == 200
      end)
    end

    test "Get a chunk of stories per pages not allowed" do
      Enum.each([0, 6, 7, 10, 243, 12], fn page ->
        conn = conn(:get, "/stories")
        conn = %{conn | host: "localhost:400/api/v1", query_params: %{"page" => "#{page}"}}
        conn = Router.call(conn, [])
        assert conn.status == 404
      end)
    end
  end
end
