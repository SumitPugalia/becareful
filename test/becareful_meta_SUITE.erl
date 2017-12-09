-module(becareful_meta_SUITE).

-include_lib("mixer/include/mixer.hrl").
-mixin([ktn_meta_SUITE]).

-export([init_per_suite/1, end_per_suite/1]).

-spec init_per_suite(becareful_ct:config()) -> becareful_ct:config().
init_per_suite(Config) -> [{application, becareful} | Config].

-spec end_per_suite(becareful_ct:config()) -> ok.
end_per_suite(_) -> ok.
