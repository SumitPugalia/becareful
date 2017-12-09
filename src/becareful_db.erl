-module(becareful_db).

%% API
-export([
  init/1,
  all/1,
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
  MS = ets:fun2ms(fun({X, Y}) -> {X, Y} end),
  ets:select(Name, MS).

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
