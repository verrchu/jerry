-module(jerry_reminder).

-include("jerry_reminder.hrl").

-export([set/1]).

-spec set(reminder()) -> ok.
set(Reminder) ->
    Instant = calculate_instant(Reminder),
    ReminderId = get_reminder_id(Reminder),
    ok = jerry_reminder_machine:set_reminder({ReminderId, Instant}).

calculate_instant(#reminder_single_from_now{} = Reminder) ->
    erlang:system_time(seconds) +
        Reminder#reminder_single_from_now.minutes * unit_to_secs(minute) +
        Reminder#reminder_single_from_now.hours * unit_to_secs(hour) +
        Reminder#reminder_single_from_now.days * unit_to_secs(day) +
        Reminder#reminder_single_from_now.weeks * unit_to_secs(week).

get_reminder_id(#reminder_single_from_now{} = Reminder) ->
    Reminder#reminder_single_from_now.id.

unit_to_secs(minute) -> 60;
unit_to_secs(hour) -> 60 * 60;
unit_to_secs(day) -> 60 * 60 * 24;
unit_to_secs(week) -> 60 * 60 * 24 * 7.

-ifdef(TEST).
-include_lib("eunit/include/eunit.hrl").

calculate_instant_minutes_test_() ->
    Reminder = #reminder_single_from_now{minutes = 10},
    ExpectedInstant = erlang:system_time(seconds) + 10 * 60,

    ?_assert(
        (ExpectedInstant - 1) =< calculate_instant(Reminder) andalso
            calculate_instant(Reminder) =< (ExpectedInstant + 1)
    ).

calculate_instant_hours_test_() ->
    Reminder = #reminder_single_from_now{hours = 10},
    ExpectedInstant = erlang:system_time(seconds) + 10 * 60 * 60,

    ?_assert(
        (ExpectedInstant - 1) =< calculate_instant(Reminder) andalso
            calculate_instant(Reminder) =< (ExpectedInstant + 1)
    ).

calculate_instant_days_test_() ->
    Reminder = #reminder_single_from_now{days = 10},
    ExpectedInstant = erlang:system_time(seconds) + 10 * 60 * 60 * 24,

    ?_assert(
        (ExpectedInstant - 1) =< calculate_instant(Reminder) andalso
            calculate_instant(Reminder) =< (ExpectedInstant + 1)
    ).

calculate_instant_weeks_test_() ->
    Reminder = #reminder_single_from_now{weeks = 10},
    ExpectedInstant = erlang:system_time(seconds) + 10 * 60 * 60 * 24 * 7,

    ?_assert(
        (ExpectedInstant - 1) =< calculate_instant(Reminder) andalso
            calculate_instant(Reminder) =< (ExpectedInstant + 1)
    ).

calculate_instant_combined_test_() ->
    Reminder = #reminder_single_from_now{minutes = 10, hours = 100, days = 1000, weeks = 10000},
    ExpectedInstant =
        erlang:system_time(seconds) +
            (10 * 60) + (100 * 60 * 60) + (1000 * 60 * 60 * 24) + (10000 * 60 * 60 * 24 * 7),

    ?_assert(
        (ExpectedInstant - 1) =< calculate_instant(Reminder) andalso
            calculate_instant(Reminder) =< (ExpectedInstant + 1)
    ).

-endif.
