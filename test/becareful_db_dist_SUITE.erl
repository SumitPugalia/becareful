-module(becareful_db_dist_SUITE).

-export([
  all/0,
  init_per_suite/1,
  end_per_suite/1
]).
-export([
  get_all_events/1,
  get_event/1,
  set_event/1,
  update_event/1
]).

-define(TABLE, event_manager).
-define(SLAVES, ['node1@127.0.0.1', 'node2@127.0.0.1']).

-spec all() -> [atom()].
all() ->
  [
    set_event,
    get_event,
    get_all_events,
    update_event
  ].

-spec init_per_suite(becareful_ct:config()) -> becareful_ct:config().
init_per_suite(Config) ->
  {ok, _} = becareful:start(),
  Nodes = start_slaves(?SLAVES),
  [{nodes, Nodes} | Config].

-spec end_per_suite(becareful_ct:config()) -> ok.
end_per_suite(_) ->
  ok = becareful:stop(),
  _ = stop_slaves(?SLAVES),
  ok.

-spec set_event(becareful_ct:config()) -> ok.
set_event(_Config) ->
  ok = becareful_db:set(?TABLE, message, 1),
  lists:foreach(fun(Node) ->
    rpc:call(Node, becareful_db, set, [?TABLE, message, 1])
  end, ?SLAVES),
  ok.

-spec get_event(becareful_ct:config()) -> ok.
get_event(_Config) ->
  3 = becareful_db:get(?TABLE, message),
  ok.

-spec get_all_events(becareful_ct:config()) -> ok.
get_all_events(_Config) ->
  [{message, 3}] = becareful_db:all(?TABLE),
  ok.

-spec update_event(becareful_ct:config()) -> ok.
update_event(_Config) ->
  ok = becareful_db:update(?TABLE, message),
  4 = becareful_db:get(?TABLE, message),
  ok.

%%%===================================================================
%%% Internal functions
%%%===================================================================

start_slaves(Slaves) ->
  start_slaves(Slaves, [], 1).

start_slaves([], Acc, _Counter) ->
  lists:usort(Acc);
start_slaves([Node | T], Acc, Counter) ->
  ErlFlags = "-pa ../../lib/*/ebin " ++
    "-config ../../../../test/dist_test" ++ integer_to_list(Counter) ++ ".config",
  {ok, HostNode} =
    ct_slave:start(Node, [
      {kill_if_fail, true},
      {monitor_master, true},
      {boot_timeout, 5000},
      {init_timeout, 3000},
      {startup_timeout, 5000},
      {startup_functions, [{becareful, start, []}]},
      {erl_flags, ErlFlags}
    ]),
  pong = net_adm:ping(HostNode),
  start_slaves(T, [HostNode | Acc], Counter + 1).

stop_slaves(Slaves) ->
  stop_slaves(Slaves, []).

stop_slaves([], Acc) ->
  lists:usort(Acc);
stop_slaves([Node | T], Acc) ->
  {ok, _Name} = ct_slave:stop(Node),
  pang = net_adm:ping(Node),
  stop_slaves(T, [Node | Acc]).
