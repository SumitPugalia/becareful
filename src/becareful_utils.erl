-module(becareful_utils).

-export([
  to_atom/1
]).

-spec to_atom(binary() |list() |atom()) -> atom().
to_atom(Value) when is_binary(Value) ->
  binary_to_atom(Value, utf8);
to_atom(Value) when is_list(Value) ->
  list_to_atom(Value);
to_atom(Value) when is_atom(Value) ->
  Value.
