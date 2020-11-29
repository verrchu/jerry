Nonterminals
expr in_expr at_expr at_day
intervals interval interval_singular interval_plural.

Terminals
in_prep
at_prep time today tomorrow
quantity_singular quantity_plural
hour_singular hour_plural
minute_singular minute_plural
day_singular day_plural
week_singular week_plural.

Rootsymbol expr.

expr -> in_expr: '$1'.
expr -> at_expr: '$1'.

in_expr -> in_prep intervals: {{single, from_now}, '$2'}.

at_expr -> at_prep time: {at, today, unwrap('$2')}.
at_expr -> at_day at_prep time: {at, '$1', unwrap('$3')}.

at_day -> today: today.
at_day -> tomorrow: tomorrow.

intervals -> interval: '$1'.
intervals -> intervals interval: '$1' ++ '$2'.

interval -> interval_singular: ['$1'].
interval -> interval_plural: ['$1'].

interval_singular -> quantity_singular minute_singular: {1, minute}.
interval_singular -> quantity_singular hour_singular: {1, hour}.
interval_singular -> quantity_singular day_singular: {1, day}.
interval_singular -> quantity_singular week_singular: {1, week}.

interval_plural -> quantity_plural minute_plural: {unwrap('$1'), minute}.
interval_plural -> quantity_plural hour_plural: {unwrap('$1'), hour}.
interval_plural -> quantity_plural day_plural: {unwrap('$1'), day}.
interval_plural -> quantity_plural week_plural: {unwrap('$1'), week}.

Erlang code.

unwrap({_,_,V}) -> V.
