-module(becareful_db).

%% API
-export([
  init/1,
  all/1,
  get/2,
  get/3,
  set/3,
  update/2
]).

-include_lib("stdlib/include/ms_transform.hrl").

%%%===================================================================
%%% Types
%%%===================================================================

-type key()   :: atom().
-type value() :: non_neg_integer().

%%%===================================================================
%%% API
%%%===================================================================

%% @doc create an ets table with write concurrency.
-spec init(atom()) -> ok.
init(Name) ->
  Name = ets:new(Name, [
    named_table,
    public,
    {write_concurrency, true}
  ]),
  ok.

%% @doc return all the records in the ets table.
-spec all(atom()) -> [{key(), value()}].
all(Name) ->
  AllEvents = lists:foldl(fun(Node, Acc) ->
                rpc:call(Node, becareful_db, all_elements, [Name]) ++ Acc
              end, all_elements(Name), nodes()),
  becareful_utils:merge_events(lists:sort(AllEvents)).

%% @doc return the value with particular key in the ets table
%% if key not found return undefined
-spec get(atom(), key()) -> value().
get(Name, Key) when is_atom(Key) ->
  get(Name, Key, 0).

%% @doc return the value with particular key in the ets table
%% if key not found return the Default value passed
-spec get(atom(), key(), any()) -> value() | any().
get(Name, Key, Default) when is_atom(Key) ->
  try
    lists:foldl(fun(Node, Acc) ->
      rpc:call(Node, becareful_db, lookup_element, [Name, Key, 2, Default]) + Acc
    end, lookup_element(Name, Key, 2, Default), nodes())
  catch
    _:_ -> Default
  end.

%% @doc insert the record in the ets table.
-spec set(atom(), key(), value()) -> ok.
set(Name, Key, Value) ->
  true = ets:insert(Name, [{Key, Value}]),
  ok.

%% @doc update the record in the ets table.
-spec update(atom(), key()) -> ok.
update(Name, Key) ->
  _ = ets:update_counter(Name, Key, 1),
  ok.
%%%===================================================================
%%% Internal Functions
%%%===================================================================

%% @private
lookup_element(Name, Key, Pos, Default) ->
  try
    ets:lookup_element(Name, Key, Pos)
  catch
    _:_ -> Default
  end.

all_elements(Name) ->
  MS = ets:fun2ms(fun({X, Y}) -> {X, Y} end),
  ets:select(Name, MS).