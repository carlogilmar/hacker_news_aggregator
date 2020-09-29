# Hacker News Aggregator

## Dependencies

I decided to use:
-  `credo` for use the static code analysis
- `httpoison` and `poison` to make http requests and encode/decode responses
- `plug`, `cowboy`, `plug_cowboy` to create the API and the websocket

## Core Design

I created a directory named `core` with all the core functionality:

![](https://res.cloudinary.com/carlogilmar/image/upload/v1601397012/Deliverables/ErlangSolutionsInterview/IMG_0168_agimjs.png)

![](https://res.cloudinary.com/carlogilmar/image/upload/v1601397011/Deliverables/ErlangSolutionsInterview/IMG_0166_xwmc2t.png)

![](https://res.cloudinary.com/carlogilmar/image/upload/v1601397011/Deliverables/ErlangSolutionsInterview/IMG_0167_zeutwl.png)

## Run this project

1. `mix deps.get`
2. `mix run --no-halt`

## Public APIs

I decided to implement basic APIs using minimal deps instead of use Phoenix.

### List stories with pagination `api/v1/stories\?page=0`

Example:
```
curl localhost:4000/api/v1/stories\?page=0
```

Constrains:
- Query params must have a param `page` with the number of the page, if this page is not sent, the API will response the page 1

### Fetch a single story `api/v1/story/:story_id`

Example:
```
curl localhost:4000/api/v1/story/24621303
```

Constrains:
- This endpoint will need the story ID, if the story is founded in the Top50, you will get the story detail, in other case you will receive a `404` code status.

### Websocket Connection

You can connect to the websocket: `ws://127.0.0.1:4001/ws/top50`

This websocket connect will receive the Top 50 stories every 5 minutes.

The websocket will send this response, the `"body"` key contains a list of the top 50 stories.

```
{"body": []}
```

## Version Control History

The commit history represents my development workflow.
