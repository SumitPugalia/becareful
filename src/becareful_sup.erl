%%%-------------------------------------------------------------------
%% @doc becareful top level supervisor.
%% @end
%%%-------------------------------------------------------------------

-module(becareful_sup).

-behaviour(supervisor).

%% API
-export([start_link/0]).

%% Supervisor callbacks
-export([init/1]).

-define(SERVER, ?MODULE).

%%====================================================================
%% API functions
%%====================================================================

start_link() ->
  supervisor:start_link({local, ?SERVER}, ?MODULE, []).

%%====================================================================
%% Supervisor callbacks
%%====================================================================

%% Child :: {Id,StartFunc,Restart,Shutdown,Type,Modules}
init([]) ->
  Child_Spec = [{activity_manager,{activity_manager,start_link,[]},
                temporary, 5000, worker, [activity_manager]}],
  {ok,{{simple_one_for_one,3,1}, Child_Spec}}.

%%====================================================================
%% Internal functions
%%====================================================================
