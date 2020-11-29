-record(reminder_single_from_now, {
    id :: binary(),
    minutes = 0 :: non_neg_integer(),
    hours = 0 :: non_neg_integer(),
    days = 0 :: non_neg_integer(),
    weeks = 0 :: non_neg_integer()
}).

-type reminder() :: #reminder_single_from_now{}.

-type from_now_interval_unit() :: minute | hour | day | week.
-type from_now_interval() :: [{pos_integer(), from_now_interval_unit()}].
