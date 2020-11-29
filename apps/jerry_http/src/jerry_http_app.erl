-module(jerry_http_app).

-behaviour(application).

-export([start/2, stop/1]).

start(_StartType, _StartArgs) ->
    Dispatch = cowboy_router:compile([
        {'_', [
            {"/notify", jerry_http_notify_handler, []}
        ]}
    ]),

    {ok, Port} = application:get_env(jerry_http, port),
    {ok, _} = cowboy:start_clear(http, [{port, Port}], #{
        env => #{dispatch => Dispatch}
    }),

    jerry_http_sup:start_link().

stop(_State) ->
    ok.
