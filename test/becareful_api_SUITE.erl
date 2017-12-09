-module(becareful_api_SUITE).

-define(TABLE, activity_manager).

-export([all/0]).
-export([init_per_suite/1, end_per_suite/1]).
-export([success/1, error/1]).

-spec all() -> [atom()].
all() ->
  [
    success,
    error
  ].

-spec init_per_suite(becareful_ct:config()) -> becareful_ct:config().
init_per_suite(Config) ->
  {ok, _} = becareful:start(),
  Config.

-spec end_per_suite(becareful_ct:config()) -> ok.
end_per_suite(_) ->
  becareful:stop().

-spec success(becareful_ct:config()) -> ok.
success(_Config) ->
  ok = becareful_api:send_activity("video"),
  ok = wait_for_success(video, 1),
  ok = becareful_api:send_activity("video"),
  ok = becareful_api:send_activity("gif"),
  ok = becareful_api:send_activity("message"),
  ok = wait_for_success(video, 2),
  ok = wait_for_success(gif, 1),
  ok = wait_for_success(message, 1),
  ok.

-spec error(becareful_ct:config()) -> ok.
error(_Config) ->
  error = becareful_api:send_activity(#{}),
  ok.

wait_for_success(Key, Value) ->
  ktn_task:wait_for_success(
    fun() ->
      Value = becareful_db:get(?TABLE, Key),
      ok
    end).
