-module(becareful_db_SUITE).

-export([
  all/0,
  init_per_suite/1,
  end_per_suite/1
]).
-export([get_all_events/1, get_event/1, set_event/1, update_event/1]).

-define(TABLE, event_manager).

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
  Config.

-spec end_per_suite(becareful_ct:config()) -> ok.
end_per_suite(_) ->
  becareful:stop().

-spec set_event(becareful_ct:config()) -> ok.
set_event(_Config) ->
  becareful_db:set(?TABLE, message, 1).

-spec get_event(becareful_ct:config()) -> ok.
get_event(_Config) ->
  1 = becareful_db:get(?TABLE, message),
  ok.

-spec get_all_events(becareful_ct:config()) -> ok.
get_all_events(_Config) ->
  [{message, 1}] = becareful_db:all(?TABLE),
  ok.

-spec update_event(becareful_ct:config()) -> ok.
update_event(_Config) ->
  ok = becareful_db:update(?TABLE, message),
  2 = becareful_db:get(?TABLE, message),
  ok.
