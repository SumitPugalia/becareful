-module(activity_manager_handler).

-behaviour(trails_handler).

-define(TABLE, activity_manager).

-type req() :: cowboy_req:req().
-type state() :: map().

-export([trails/0]).
-export([init/3,
  rest_init/2,
  content_types_provided/2,
  allowed_methods/2,
  resource_exists/2]).
-export([handle_get/2]).

%% @doc This function allows you to add additional information to the
%% `cowboy' handler, such as: resource path, handler module,
%% options and metadata. Normally used to document handlers.
-spec trails() -> [trails:trail()].
trails() ->
  GetMetadata = #{
    get => #{
      tags => ["Product Info"],
      description => "Behavioural analytics of the Product",
      parameters => [
        #{
          name => <<"event_name">>,
          description => <<"Number of times the event was fired">>,
          in => <<"path">>,
          required => false,
          type => <<"string">>
        }
      ],
      produces => ["application/json"],
      responses => #{
        200 => #{
          description => "Information about the event",
          schema => #{
            type => <<"object">>
          }
        },
        404 => #{description => "Event not found"}
      }
    }
  },
  [trails:trail("/events/[:event_name]", ?MODULE, [], GetMetadata)].

%% @doc Upgrades to cowboy_rest.
%% Basically, just returns <code>{upgrade, protocol, cowboy_rest}</code>
%% @see cowboy_rest:init/3
-spec init(term(), req(), []) -> {upgrade, protocol, cowboy_rest}.
init(_Transport, _Req, _Opts) ->
  {upgrade, protocol, cowboy_rest}.

%% @doc Announces the Req and moves on.
%% If <code>verbose := true</code> in <code>Opts</code> for this handler
%% prints out a line indicating that endpoint that was hit.
%% @see cowboy_rest:rest_init/2
-spec rest_init(req(), term()) -> {ok, req(), state()}.
rest_init(Req, _Opts) ->
  {ok, Req, #{}}.

%% @doc Always returns "application/json" with <code>handle_get</code>.
%% @see cowboy_rest:content_types_provided/2
-spec content_types_provided(req(), state()) -> {list(), req(), state()}.
content_types_provided(Req, State) ->
  {[{<<"application/json">>, handle_get}], Req, State}.

%% @doc Retrieves the list of allowed methods from Trails metadata.
%% Parses the metadata associated with this path and returns the
%% corresponding list of endpoints.
%% @see cowboy_rest:allowed_methods/2
-spec allowed_methods(req(), state()) -> {list(), req(), state()}.
allowed_methods(Req, State) ->
  {[<<"GET">>], Req, State}.

-spec resource_exists(req(), state()) -> {boolean(), req(), state()}.
resource_exists(Req, State) ->
  {Method, Req1} = cowboy_req:method(Req),
  {Event, Req2} = cowboy_req:binding(event_name, Req1),
  case {Method, Event} of
    {<<"GET">>, Event} when Event == <<"{event_name}">> orelse Event == undefined ->
        Info = becareful_db:all(?TABLE),
        {true, Req2, State#{event_info => Info}};
    {<<"GET">>, _} ->
      case becareful_db:get(?TABLE, becareful_utils:to_atom(Event)) of
        undefined ->
          {false, Req2, State};
        Info ->
          {true, Req2, State#{event_info => Info}}
      end
  end.

%% @doc Returns the Info for the Event.
-spec handle_get(req(), state()) -> {binary(), req(), state()}.
handle_get(Req, State) ->
  #{event_info := Info} = State,
  {becareful_utils:encode(Info), Req, State}.
