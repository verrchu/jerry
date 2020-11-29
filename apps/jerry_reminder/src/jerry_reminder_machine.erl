-module(jerry_reminder_machine).

-behaviour(gen_server).

-export([start_link/0, set_reminder/1]).
-export([
    init/1,
    terminate/2,
    code_change/3,
    handle_call/3,
    handle_cast/2,
    handle_info/2
]).

-define(DATA, jerry_reminder_data).

start_link() ->
    gen_server:start_link({local, ?MODULE}, ?MODULE, [], []).

init([]) ->
    ok = init_data(),
    {ok, {}}.

handle_call({set_reminder, {Id, Instant}}, _From, State) ->
    {reply, ok, State};
handle_call(_Msg, _From, State) ->
    {reply, ok, State}.

handle_cast(_Msg, State) ->
    {noreply, State}.

handle_info(_Msg, State) ->
    {noreply, State}.

terminate(_Reason, _State) -> ok.

code_change(_OldVsn, _NewVsn, State) -> {ok, State}.

set_reminder({Id, Instant}) ->
    ok = gen_server:call(?MODULE, {set_reminder, {Id, Instant}}).

init_data() ->
    DataFile = filename:join([code:priv_dir(jerry_reminder), "machine_data"]),
    {ok, ?DATA} = dets:open_file(?DATA, [{file, DataFile}]),

    ok.
