-module(jerry_session_impl).

-behaviour(gen_statem).

-include_lib("kernel/include/logger.hrl").

-record(data, {reminder_description}).

-define(STATE_AWAITING_COMMAND(), awaiting_command).
-define(STATE_AWAITING_REMINDER_DESCRIPTION(), awaiting_reminder_description).
-define(STATE_AWAITING_REMINDER_INTERVAL(), awaiting_reminder_interval).

-define(COMMAND_NEW(), <<"/new">>).
-define(COMMAND_CANCEL(), <<"/cancel">>).

-export([
    init/1,
    terminate/3,
    handle_event/4,
    code_change/4,
    callback_mode/0
]).

callback_mode() -> handle_event_function.

init([_ChatId]) ->
    {ok, ?STATE_AWAITING_COMMAND(), #data{}}.

handle_event({call, From}, ?COMMAND_NEW() = Msg, State0, Data0) ->
    ?LOG_DEBUG({"msg: ~p; s: ~p; d: ~p", [Msg, State0, Data0]}),
    ok = gen_statem:reply(From, ok),
    Data1 = #data{},
    State1 = ?STATE_AWAITING_REMINDER_DESCRIPTION(),
    ?LOG_DEBUG({"os: ~p; ns: ~p; od: ~p; nd: ~p", [State0, State1, Data0, Data1]}),
    {next_state, State1, Data1};
handle_event({call, From}, ?COMMAND_CANCEL() = Msg, State0, Data0) ->
    ?LOG_DEBUG({"msg: ~p; s: ~p; d: ~p", [Msg, State0, Data0]}),
    ok = gen_statem:reply(From, ok),
    Data1 = #data{},
    State1 = ?STATE_AWAITING_COMMAND(),
    ?LOG_DEBUG({"os: ~p; ns: ~p; od: ~p; nd: ~p", [State0, State1, Data0, Data1]}),
    {next_state, State1, Data1};
handle_event({call, From}, Msg, ?STATE_AWAITING_REMINDER_DESCRIPTION() = State0, Data0) ->
    ?LOG_DEBUG({"msg: ~p; s: ~p; d: ~p", [Msg, State0, Data0]}),
    ok = gen_statem:reply(From, ok),
    Data1 = Data0#data{reminder_description = Msg},
    State1 = ?STATE_AWAITING_REMINDER_INTERVAL(),
    ?LOG_DEBUG({"os: ~p; ns: ~p; od: ~p; nd: ~p", [State0, State1, Data0, Data1]}),
    {next_state, State1, Data1};
handle_event({call, From}, Msg, ?STATE_AWAITING_REMINDER_INTERVAL() = State0, Data0) ->
    ?LOG_DEBUG({"msg: ~p; s: ~p; d: ~p", [Msg, State0, Data0]}),
    ok = gen_statem:reply(From, ok),
    Data1 = #data{},
    State1 = ?STATE_AWAITING_COMMAND(),
    ?LOG_DEBUG({"os: ~p; ns: ~p; od: ~p; nd: ~p", [State0, State1, Data0, Data1]}),
    {next_state, State1, Data1};
handle_event({call, From}, Msg, State, Data) ->
    ?LOG_DEBUG({"[UNEXPECTED] msg: ~p; s: ~p; d: ~p", [{call, Msg}, State, Data]}),
    ok = gen_statem:reply(From, ok),
    {next_state, State, Data};
handle_event(MsgType, Msg, State, Data) ->
    ?LOG_DEBUG({"[UNEXPECTED] msg: ~p; s: ~p; d: ~p", [{MsgType, Msg}, State, Data]}),
    {next_state, State, Data}.

terminate(_Reason, _State, _Data) -> ok.

code_change(_Vsn, State, Data, _Extra) ->
    {ok, State, Data}.
