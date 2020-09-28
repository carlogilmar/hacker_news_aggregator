use Mix.Config

config :hacker_news_aggregator, api: "https://hacker-news.firebaseio.com/v0"

import_config "#{Mix.env()}.exs"
