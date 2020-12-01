-module(jerry_session_registry).

-include_lib("kernel/include/logger.hrl").

-define(SERVER, jerry_session_registry_impl).

-export([get_session/1]).
-export([start_link/0]).

start_link() ->
    gen_server:start_link({local, ?SERVER}, ?SERVER, [], []).

-spec get_session(pos_integer()) -> {ok, pid()}.
get_session(ChatId) ->
    {ok, _Pid} = gen_server:call(?SERVER, {get_session, ChatId}).
