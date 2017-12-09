-module(becareful_utils_SUITE).

-export([all/0]).
-export([to_atom/1]).

-spec all() -> [atom()].
all() -> [to_atom].

-spec to_atom(becareful_ct:config()) -> ok.
to_atom(_Config) ->
  message = becareful_utils:to_atom(<<"message">>),
  message = becareful_utils:to_atom("message"),
  message = becareful_utils:to_atom(message),
  ok.
