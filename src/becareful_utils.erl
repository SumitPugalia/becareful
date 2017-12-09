-module(becareful_utils).

-export([
  to_atom/1,
  encode/1,
  decode/1,
  merge_events/1
]).

-spec to_atom(binary() |list() |atom()) -> atom().
to_atom(Value) when is_binary(Value) ->
  binary_to_atom(Value, utf8);
to_atom(Value) when is_list(Value) ->
  list_to_atom(Value);
to_atom(Value) when is_atom(Value) ->
  Value.

-spec encode(jsx:json_term()) -> jsx:json_text().
encode(Data) ->
  jsx:encode(Data, [uescape]).

%% @doc this function decodes the provided data and return maps
-spec decode(jsx:json_text()) -> jsx:json_term().
decode(Data) ->
  try
    jsx:decode(Data, [return_maps])
  catch
    _:_ -> throw({bad_json, Data})
  end.

-spec merge_events(list()) -> list().
merge_events(Events) ->
  {LEvent, LCount, Result} = lists:foldl(fun(Event, Acc) ->
                              {EventName, Count} = Event,
                              {PEventName, PCount, NewAcc} = Acc,
                              case PEventName of
                                EventName ->
                                  {PEventName, PCount + Count, NewAcc};
                                0 ->
                                  {EventName, Count, NewAcc};
                                _ ->
                                  {EventName, Count, NewAcc ++ [{PEventName, PCount}]}
                                end
                              end, {0, 0, []}, Events),
  Result ++ [{LEvent, LCount}].