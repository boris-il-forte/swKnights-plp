member(X,[X|_]).
member(X,[_|T]) :- member(X,T).

a2b([],[]).
a2b([a|Rest1],[b|Rest2]) :- a2b(Rest1, Rest2).

second(X,[_,X|_]). 
