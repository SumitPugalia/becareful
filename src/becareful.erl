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
  becareful_sup:start_link().

%% @doc Stops the app
-spec stop() -> ok.
stop() ->
  application:stop(becareful).

stop(_State) ->
  ok.

%%====================================================================
%% Internal functions
%%====================================================================
