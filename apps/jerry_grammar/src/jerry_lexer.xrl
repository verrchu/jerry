Definitions.

WS = [\s\t]
LB = \n|\r\n|\r

SINGULAR = 1
PLURAL = [1-9][0-9]*

TIME = ([1-9]|0[1-9]|1[1-9]|2[0-3]):[0-5][0-9]

Rules.

{SINGULAR} : {token, {quantity_singular, TokenLine}}.
{PLURAL} : {token, {quantity_plural, TokenLine, list_to_integer(TokenChars)}}.
{TIME} : {token, {time, TokenLine, list_to_binary(TokenChars)}}.

today : {token, {today, TokenLine}}.
tomorrow : {token, {tomorrow, TokenLine}}.

in : {token, {in_prep, TokenLine}}.
at : {token, {at_prep, TokenLine}}.

hour : {token, {hour_singular, TokenLine}}.
hours : {token, {hour_plural, TokenLine}}.
minute : {token, {minute_singular, TokenLine}}.
minutes : {token, {minute_plural, TokenLine}}.
day : {token, {day_singular, TokenLine}}.
days : {token, {day_plural, TokenLine}}.
week : {token, {week_singular, TokenLine}}.
weeks : {token, {week_plural, TokenLine}}.

,|and : skip_token.

{LB} : skip_token.
{WS} : skip_token.

Erlang code.
