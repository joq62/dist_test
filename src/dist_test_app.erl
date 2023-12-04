%%%-------------------------------------------------------------------
%% @doc adder public API
%% @end
%%%-------------------------------------------------------------------

-module(dist_test_app).

-behaviour(application).

-export([start/2, stop/1]).

start(_StartType, _StartArgs) ->
    dist_test_sup:start_link().

stop(_State) ->
    ok.

%% internal functions
