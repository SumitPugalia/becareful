-module(becareful_api).

-export([
  send_event/1
]).

-spec send_event(any()) -> ok | error.
send_event(Event) when is_binary(Event);
  is_list(Event);is_atom(Event) ->
  WorkerName = becareful_utils:to_atom(Event),
  case whereis(WorkerName) of
    undefined ->
      start_worker(WorkerName);
    _ ->
      _ = WorkerName ! {received_event, WorkerName},
      ok
  end;
send_event(_Event) ->
  error.

%% private
start_worker(WorkerName) ->
  case supervisor:start_child(becareful_sup, [WorkerName]) of
    {ok, _} ->
      WorkerName ! {received_event, WorkerName},
      ok;
    _ ->
      error
  end.