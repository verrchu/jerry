-module(jerry_http_notify_handler).

-include_lib("kernel/include/logger.hrl").

-export([init/2]).

init(Req0, Opts) ->
    {ok, Body0, Req1} = cowboy_req:read_body(Req0),
    Req2 = cowboy_req:reply(200, Req1),
    Body1 = jiffy:decode(Body0, [return_maps]),
    ?LOG_DEBUG({"http msg: ~p", [Body1]}),
    ok = jerry_session:recv(Body1),
    {ok, Req2, Opts}.
