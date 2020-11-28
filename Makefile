REBAR = ./rebar3

compile:
	$(REBAR) compile

release: compile
	$(REBAR) release

format:
	$(REBAR) fmt
