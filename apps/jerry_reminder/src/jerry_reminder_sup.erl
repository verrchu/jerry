-module(jerry_reminder_sup).

-behaviour(supervisor).

-export([start_link/0]).
-export([init/1]).

start_link() ->
    supervisor:start_link({local, ?MODULE}, ?MODULE, []).

init([]) ->
    SupFlags = #{
        strategy => one_for_one,
        intensity => 4,
        period => 1
    },
    ChildSpecs = [
        #{
            id => jerry_reminder_machine,
            start => {jerry_reminder_machine, start_link, []}
        }
    ],
    {ok, {SupFlags, ChildSpecs}}.
