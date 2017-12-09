%%%-------------------------------------------------------------------
%% @doc becareful public API
%% @end
%%%-------------------------------------------------------------------

-module(becareful).

-behaviour(application).

%%% API
-export([start/0, stop/0]).

%%% Callbacks
-export([start/2, stop/1]).

%%====================================================================
%% API
%%====================================================================
%% @doc Starts the app
-spec start() -> {ok, [atom()]}.
start() ->
  application:ensure_all_started(becareful).

start(_StartType, _StartArgs) ->
  {ok, _Pid} = start_http(),
  becareful_sup:start_link().

%% @doc Stops the app
-spec stop() -> ok.
stop() ->
  ok = stop_http(),
  application:stop(becareful).

stop(_State) ->
  ok.

%%====================================================================
%% Internal functions
%%====================================================================

%% private
start_http() ->
  {ok, #{port := Port,
         acceptors := Acceptors}} = application:get_env(becareful, webserver),
  Trails = trails:trails([
    cowboy_swagger_handler,
    activity_manager_handler
  ]),
  trails:store(Trails),
  Dispatch = trails:single_host_compile(Trails),
  cowboy:start_http(becareful_http, Acceptors, [{port, Port}], [{env, [{dispatch, Dispatch}]}]).

%% private
stop_http() ->
  cowboy:stop_listener(becareful_http).
