-module(jerry_session).

-behaviour(gen_server).

-export([start_monitor/1]).
-export([
    init/1,
    terminate/2,
    code_change/3,
    handle_call/3,
    handle_cast/2,
    handle_info/2
]).

start_monitor(ChatId) ->
    gen_server:start_monitor(?MODULE, [ChatId], []).

init([_ChatId]) ->
    {ok, {}}.

handle_call(_Msg, _From, State) ->
    {reply, ok, State}.

handle_cast(_Msg, State) ->
    {noreply, State}.

handle_info(_Msg, State) ->
    {noreply, State}.

terminate(_Reason, _State) -> ok.

code_change(_OldVsn, _NewVsn, State) -> {ok, State}.
