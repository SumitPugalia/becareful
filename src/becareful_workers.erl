%%%-------------------------------------------------------------------
%%% @doc
%%% Pollable Channel Worker.
%%% @end
%%%-------------------------------------------------------------------
-module(becareful_workers).

-behaviour(gen_server).

-define(TABLE, activity_manager).
%% API
-export([
  start_link/1
]).

%% gen_server callbacks
-export([
  init/1,
  handle_call/3,
  handle_cast/2,
  handle_info/2,
  terminate/2
]).

%%%===================================================================
%%% API
%%%===================================================================

start_link(Name) ->
  gen_server:start_link({local, Name}, ?MODULE, [Name], []).

%%%===================================================================
%%% gen_server callbacks
%%%===================================================================

%% @hidden
init([Name]) ->
  ok = becareful_db:set(?TABLE, Name, 0),
  {ok, #{}}.

%% @hidden
handle_call(_Request, _From, State) ->
  {reply, ok, State}.

%% @hidden
handle_cast(_Request, State) ->
  {noreply, State}.

%% @hidden
handle_info({received_event, Name}, State) ->
  ok = becareful_db:update(?TABLE, Name),
  {noreply, State}.

%% @hidden
terminate(_Reason, _State) ->
  ok.

%%%===================================================================
%%% Internal functions
%%%===================================================================
