REBAR = ./rebar3

compile:
	@ $(REBAR) compile

release: compile
	@ printf "CHECK PROFILE: " && test -n "$(PROFILE)" && printf "OK\n"
	@ $(REBAR) as $(PROFILE) release

console: release
	@ printf "CHECK PROFILE: " && test -n "$(PROFILE)" && printf "OK\n"
	@ ./_build/$(PROFILE)/rel/jerry/bin/jerry console

format:
	@ $(REBAR) fmt

eunit:
	@ $(REBAR) eunit

dialyzer: compile
	@ $(REBAR) dialyzer
