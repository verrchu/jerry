-module(jerry_http_notify_handler).

-include_lib("kernel/include/logger.hrl").

-export([init/2]).

init(Req0, Opts) ->
    {ok, Body, Req1} = cowboy_req:read_body(Req0),
    ?LOG_DEBUG({"EVENT :: ~p", [{body, Body}]}),
    Req2 = cowboy_req:reply(200, Req1),
    {ok, Req2, Opts}.
