-module(becareful_test_http).

-include_lib("common_test/include/ct.hrl").

-type http_result() :: {pos_integer(), map() | no_content} | {error, term()}.

-export([get/1]).

-spec get(binary()) -> http_result().
get(Path) ->
  case hackney:get(url(Path)) of
    {ok, 404, _RespHeaders, Ref} ->
      _ = hackney:close(Ref),
      {404, <<>>};
    {ok, HttpCode, _RespHeaders, Ref} ->
      {ok, RespBody} = hackney:body(Ref),
      _ = hackney:close(Ref),
      {HttpCode, becareful_utils:decode(RespBody)};
    ErrorResponse ->
      {error, ErrorResponse}
  end.

url(Path) ->
  {ok, #{port := Port}} = application:get_env(becareful, webserver),
  <<"http://localhost:", (integer_to_binary(Port))/binary, Path/binary>>.