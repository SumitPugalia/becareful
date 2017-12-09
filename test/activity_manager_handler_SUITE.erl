-module(activity_manager_handler_SUITE).

-include_lib("common_test/include/ct.hrl").

-define(TABLE, activity_manager).

-export([
  all/0,
  init_per_suite/1,
  end_per_suite/1,
  init_per_testcase/2,
  end_per_testcase/2
]).

-export([get_success/1, get_error/1]).

-spec all() -> [atom()].
all() ->
  [
    get_success,
    get_error
  ].

-spec init_per_suite(becareful_ct:config()) -> becareful_ct:config().
init_per_suite(Config) ->
  _ = application:ensure_all_started(hackney),
  _ = becareful:start(),
  Config.

-spec end_per_suite(becareful_ct:config()) -> ok.
end_per_suite(_) ->
  ok = becareful:stop(),
  ok = application:stop(hackney),
  ok.

-spec init_per_testcase(any(), becareful_ct:config()) -> becareful_ct:config().
init_per_testcase(get_success, Config) ->
  ok = becareful_db:set(?TABLE, message, 1),
  Config;
init_per_testcase(_Case, Config) ->
  Config.

-spec end_per_testcase(any(), becareful_ct:config()) -> ok.
end_per_testcase(_Case, _Config) ->
  ok.

-spec get_success(becareful_ct:config()) -> ok.
get_success(_Config) ->
  {200, #{<<"message">> := 1}} = becareful_test_http:get(get_path(undefined)),
  {200, 1} = becareful_test_http:get(get_path(<<"message">>)),
  ok.

-spec get_error(becareful_ct:config()) -> ok.
get_error(_Config) ->
  {404, _} = becareful_test_http:get(get_path(<<"video">>)),
  ok.

%% private
get_path(undefined) ->
  <<"/events">>;
get_path(EventName) ->
  <<"/events/", EventName/binary>>.
