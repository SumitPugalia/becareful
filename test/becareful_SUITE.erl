-module(becareful_SUITE).

-export([all/0]).
-export([application_api/1]).

-spec all() -> [application_api].
all() -> [application_api].

-spec application_api(becareful_ct:config()) -> ok.
application_api(_Config) ->
  false = is_app_running(),
  {ok, _} = becareful:start(),
  true = is_app_running(),
  Pid = erlang:whereis(becareful_sup),
  true = erlang:is_pid(Pid),
  ok = becareful:stop(),
  false = is_app_running(),
  ok.

%% private
is_app_running() ->
  lists:member(becareful, [App || {App, _, _} <- application:which_applications()]).