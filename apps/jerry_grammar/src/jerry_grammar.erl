-module(jerry_grammar).

-include_lib("jerry_reminder/include/jerry_reminder.hrl").

-export([process/1]).

-spec process(string()) -> {ok, reminder()} | {error, atom()}.
process(Input) ->
    {ok, Tokens, _} = jerry_lexer:string(Input),
    {ok, Data} = jerry_parser:parse(Tokens),

    wrap(Data).

-spec wrap(any()) -> {ok, reminder()} | {error, atom()}.
wrap({{single, from_now}, Interval}) ->
    case check_from_now_interval(Interval) of
        ok ->
            Reminder = #reminder_single_from_now{
                id = ulid:generate(),
                minutes = get_from_now_unit_quantity(Interval, minute),
                hours = get_from_now_unit_quantity(Interval, hour),
                days = get_from_now_unit_quantity(Interval, day),
                weeks = get_from_now_unit_quantity(Interval, week)
            },
            {ok, Reminder};
        {error, _Error} = Error ->
            Error
    end.

-spec check_from_now_interval(from_now_interval()) -> ok | {error, atom()}.
check_from_now_interval(Interval) ->
    Units = lists:map(fun({_N, Unit}) -> Unit end, Interval),
    case length(Interval) > length(lists:usort(Units)) of
        true -> {error, duplicate_interval_unit};
        false -> ok
    end.

-spec get_from_now_unit_quantity(from_now_interval(), from_now_interval_unit()) ->
    non_neg_integer().
get_from_now_unit_quantity(Interval, Unit) ->
    case lists:keyfind(Unit, 2, Interval) of
        {Quantity, Unit} -> Quantity;
        false -> 0
    end.

-ifdef(TEST).
-include_lib("eunit/include/eunit.hrl").

check_from_now_interval_test_() ->
    [
        ?_assertEqual(ok, check_from_now_interval([{1, day}])),
        ?_assertEqual(ok, check_from_now_interval([{1, day}, {1, hour}])),
        ?_assertEqual(
            {error, duplicate_interval_unit},
            check_from_now_interval([{1, day}, {1, day}])
        )
    ].

get_from_now_unit_quantity_test() ->
    [
        ?_assertEqual(1, get_from_now_unit_quantity([{1, day}], day)),
        ?_assertEqual(0, get_from_now_unit_quantity([{1, hour}], day))
    ].

parse_test_() ->
    [
        ?_assertMatch(
            {ok, #reminder_single_from_now{minutes = 1, hours = 0, days = 0, weeks = 0}},
            process("in 1 minute")
        ),
        ?_assertMatch(
            {ok, #reminder_single_from_now{minutes = 10, hours = 0, days = 0, weeks = 0}},
            process("in 10 minutes")
        ),

        ?_assertMatch(
            {ok, #reminder_single_from_now{minutes = 0, hours = 1, days = 0, weeks = 0}},
            process("in 1 hour")
        ),
        ?_assertMatch(
            {ok, #reminder_single_from_now{minutes = 0, hours = 10, days = 0, weeks = 0}},
            process("in 10 hours")
        ),

        ?_assertMatch(
            {ok, #reminder_single_from_now{minutes = 0, hours = 0, days = 1, weeks = 0}},
            process("in 1 day")
        ),
        ?_assertMatch(
            {ok, #reminder_single_from_now{minutes = 0, hours = 0, days = 10, weeks = 0}},
            process("in 10 days")
        ),

        ?_assertMatch(
            {ok, #reminder_single_from_now{minutes = 0, hours = 0, days = 0, weeks = 1}},
            process("in 1 week")
        ),
        ?_assertMatch(
            {ok, #reminder_single_from_now{minutes = 0, hours = 0, days = 0, weeks = 10}},
            process("in 10 weeks")
        ),

        ?_assertMatch(
            {ok, #reminder_single_from_now{minutes = 1, hours = 1, days = 1, weeks = 1}},
            process("in 1 week 1 day 1 hour 1 minute")
        ),
        ?_assertMatch(
            {ok, #reminder_single_from_now{minutes = 1, hours = 1, days = 1, weeks = 1}},
            process("in 1 week, 1 day, 1 hour, 1 minute")
        ),
        ?_assertMatch(
            {ok, #reminder_single_from_now{minutes = 1, hours = 1, days = 1, weeks = 1}},
            process("in 1 week and 1 day and 1 hour and 1 minute")
        )
    ].
-endif.
