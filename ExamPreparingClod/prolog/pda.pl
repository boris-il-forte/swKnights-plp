
% una configurazione è finale se il suo stato è finale e non ha piu nulla in input da leggere
config(State, _ ,[]) :- final(State), !.

%=========== mosse standard dell automa===========

config(State, [Top|Rest], [C|String]) :- delta(State, C, Top, NewState, Push), !,
													  append(Push, Rest, NewStack),
													  config(NewState, NewStack, String).

config(State, [Top|Rest], String) :- delta(State, epsilon, Top, NewState, Push), !,
													  append(Push, Rest, NewStack),
													  config(NewState, NewStack, String).

run(Input) := initial(Q), config(Q, [z0], Input]	
