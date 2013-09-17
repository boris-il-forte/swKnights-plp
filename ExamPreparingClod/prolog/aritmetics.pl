

listLenght([],0).
listLenght([_|T], N) :- listLenght(T,X), N is X+1.

accLen([_|T],A,L) :- An is A+1, accLen(T,An,L).
accLen([],A,A).

len(L,N) :- accLen(L,0,N).

accMax([H|T], A, M) :- H > A, accMax(T, H, M).
accMax([H|T], A, M) :- H =< A, accMax(T, A, M).
accMax([],A,A).

max([H|T], M) :- accMax([H|T],H,M).

increment(X,Y) :- X is Y - 1.

my_sum(X,Y,Z) :- Z is X + Y.

addOne([],[]).
addOne([H1|T1],[H2|T2]) :- addOne(T1,T2), H2 is H1+1.

scalMul(N, [H1|T1], [H2|T2]) :- scalMul(N,T1,T2), H2 is N*H1.
scalMul(_,[],[]).

doAccProd([H1|T1], [H2|T2], A, R) :- An is A+H1*H2, doAccProd(T1,T2,An,R).
doAccProd([],[],A,A).

dot(L1, L2, R) :- doAccProd(L1,L2,0,R).
