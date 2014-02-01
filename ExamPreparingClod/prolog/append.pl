
member(X,[X|_]).
member(X,[_|T]) :- member(X,T).

remdupl([],[]).
remdupl([X|Xs],[X|Ys]) :- not(member(X,Xs)), remdupl(Xs,Ys).
remdupl([X|Xs],Out) :- member(X,Xs), remdupl(Xs,Out).


