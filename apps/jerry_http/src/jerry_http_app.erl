%%%-------------------------------------------------------------------
%% @doc jerry_http public API
%% @end
%%%-------------------------------------------------------------------

-module(jerry_http_app).

-behaviour(application).

-export([start/2, stop/1]).

start(_StartType, _StartArgs) ->
    jerry_http_sup:start_link().

stop(_State) ->
    ok.

%% internal functions
