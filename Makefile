REBAR = ./rebar3

compile:
	$(REBAR) compile

release: compile
	$(REBAR) release

console: release
	./_build/default/rel/jerry/bin/jerry console

format:
	$(REBAR) fmt

eunit:
	$(REBAR) eunit
