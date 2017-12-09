-module(becareful_utils_SUITE).

-export([all/0]).
-export([to_atom/1, merge_events/1]).

-spec all() -> [atom()].
all() ->
  [
    to_atom,
    merge_events
  ].

-spec to_atom(becareful_ct:config()) -> ok.
to_atom(_Config) ->
  message = becareful_utils:to_atom(<<"message">>),
  message = becareful_utils:to_atom("message"),
  message = becareful_utils:to_atom(message),
  ok.

-spec merge_events(becareful_ct:config()) -> ok.
merge_events(_Config) ->
  Events = [{message, 1}, {chat, 1}, {video, 2}, {message, 3}, {video, 2}, {video, 3}],
  [{chat, 1}, {message, 4}, {video, 7}] = becareful_utils:merge_events(lists:sort(Events)),
  ok.
