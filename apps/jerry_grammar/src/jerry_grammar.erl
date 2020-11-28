-module(jerry_grammar).

-export([process/1]).

process(Input) ->
    {ok, Tokens, _} = jerry_lexer:string(Input),
    {ok, Data} = jerry_parser:parse(Tokens),

    {ok, Data}.
