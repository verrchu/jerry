-module(jerry_session).

-define(SERVER, jerry_session_impl).

-export([start_monitor/1]).
-export([recv/1]).

start_monitor(ChatId) ->
    gen_statem:start_monitor(?SERVER, [ChatId], []).

recv(Msg) -> ok.
