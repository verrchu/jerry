-module(jerry_session_impl).

-behaviour(gen_statem).

-export([
    init/1,
    terminate/3,
    handle_event/4,
    code_change/4,
    callback_mode/0
]).

callback_mode() -> handle_event_function.

init([_ChatId]) ->
    {ok, {}, {}}.

handle_event(_EventType, _EventContent, State, Data) ->
    {next_state, State, Data}.

terminate(_Reason, _State, _Data) -> ok.

code_change(_Vsn, State, Data, _Extra) ->
    {ok, State, Data}.
