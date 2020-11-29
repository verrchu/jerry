-module(jerry_session_registry).

-behaviour(gen_server).

-include_lib("kernel/include/logger.hrl").

-record(state, {mapping = [] :: [{pos_integer(), pid()}]}).

-export([get_session/1]).

-export([start_link/0]).
-export([
    init/1,
    terminate/2,
    code_change/3,
    handle_call/3,
    handle_cast/2,
    handle_info/2
]).

start_link() ->
    gen_server:start_link({local, ?MODULE}, ?MODULE, [], []).

init([]) ->
    {ok, #state{}}.

get_session(ChatId) ->
    {ok, _Pid} = gen_server:call(?MODULE, {get_session, ChatId}).

handle_call({get_session, ChatId}, _From, #state{mapping = Mapping0} = State0) ->
    {Pid2, State2} =
        case lists:keyfind(ChatId, 1, Mapping0) of
            {ChatId, Pid0} ->
                case is_process_alive(Pid0) of
                    true ->
                        {Pid0, State0};
                    false ->
                        {ok, {Pid1, _Mon}} = jerry_session:start_monitor(ChatId),
                        Mapping1 = lists:keyreplace(ChatId, 1, Mapping0, {ChatId, Pid1}),
                        State1 = State0#state{mapping = Mapping1},
                        {Pid1, State1}
                end;
            false ->
                {ok, {Pid0, _Ref}} = jerry_session:start_monitor(ChatId),
                Mapping1 = lists:keystore(ChatId, 1, Mapping0, {ChatId, Pid0}),
                State1 = State0#state{mapping = Mapping1},
                {Pid0, State1}
        end,
    {reply, {ok, Pid2}, State2};
handle_call(_Msg, _From, State) ->
    {reply, ok, State}.

handle_cast(_Msg, State) ->
    {noreply, State}.

handle_info({'DOWN', _Ref, process, Pid, Reason}, #state{mapping = Mapping0} = State0) ->
    {value, {ChatId, Pid}, Mapping1} = lists:keytake(Pid, 2, Mapping0),
    case Reason of
        normal ->
            ?LOG_INFO({"SESSION TERMINATED :: CHAT -> ~p | REASON -> ~p", [ChatId, Reason]});
        Reason ->
            ?LOG_ERROR({"SESSION TERMINATED :: CHAT -> ~p | REASON -> ~p", [ChatId, Reason]})
    end,
    {noreply, State0#state{mapping = Mapping1}};
handle_info(_Msg, State) ->
    {noreply, State}.

terminate(_Reason, _State) -> ok.

code_change(_OldVsn, _NewVsn, State) -> {ok, State}.
