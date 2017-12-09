%%%-------------------------------------------------------------------
%%% @doc
%%% Pollable Channel Worker.
%%% @end
%%%-------------------------------------------------------------------
-module(activity_manager).

-behaviour(gen_server).

%% API
-export([
  start_link/1,
  start_link/0
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

%% @equiv start_link(Opts, #{})
start_link() ->
  gen_server:start_link(?MODULE, [], []).

start_link(Name) ->
  gen_server:start_link({local, Name}, ?MODULE, [], []).

%%%===================================================================
%%% gen_server callbacks
%%%===================================================================

%% @hidden
init([]) ->
  {ok, #{}}.

%% @hidden
handle_call(_Request, _From, State) ->
  {reply, ok, State}.

%% @hidden
handle_cast(_Request, State) ->
  {noreply, State}.

%% @hidden
handle_info(received_event, State) ->
  %%erlang:display(gotthemessage),
  {noreply, State}.

%% @hidden
terminate(_Reason, _State) ->
  ok.

%%%===================================================================
%%% Internal functions
%%%===================================================================
