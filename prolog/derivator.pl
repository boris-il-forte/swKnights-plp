%% Derivator frontend

derive(X, _, 0, Y) :- !, simplify(X, Y).
derive(X, T, N, Y) :- integer(N), !, K is N-1, d(X, T, W), derive(W, T, K, Y).

%% Internal derivation function
d(X+Y, T, DX+DY) :- !, d(X, T, DX), d(Y, T, DY).
d(X-Y, T, DY-DX) :- !, d(X, T, DX), d(Y, T, DY).
d(X*Y, T, DX*Y+X*DY) :- !, d(X, T, DX), d(Y, T, DY).
d(X^N, T, N*X^K*DX) :- !, integer(N), K is N-1, d(X, T, DX).
d(-X, T, -DX) :- !,  d(X, T, DX).
d(X, X, 1) :- !.
d(C, _, 0) :- atomic(C), !.
