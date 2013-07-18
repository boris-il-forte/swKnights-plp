% Derivator
% extended prolog version of Pradella's Prolog derivator 
% Davide Tateo <boris.ilpossente@hotmail.it>

% import simplifier
:- [simplifier].

% Derivator frontend
derive(X, _, 0, Y) :- !, simplify(X, Y).
derive(X, T, N, Y) :- integer(N), !, K is N-1, d(X, T, W), derive(W, T, K, Y).

gradient(_, [], []) :- !.
gradient(X, [T|V], [DXDT|R]) :- !, derive(X, T, 1,DXDT), gradient(X, V, R).

% Internal derivation function
d(X+Y, T, DX+DY) :- !, d(X, T, DX), d(Y, T, DY).
d(X-Y, T, DY-DX) :- !, d(X, T, DX), d(Y, T, DY).
d(X*Y, T, DX*Y+X*DY) :- !, d(X, T, DX), d(Y, T, DY).
d(X/Y, T, (DX-DY)/Y^2) :- !, d(X, T, DX), d(Y, T, DY).
d(X^N, T, N*X^K*DX) :- !, integer(N), K is N-1, d(X, T, DX).
d(-X, T, -DX) :- !,  d(X, T, DX).
d(X, X, 1) :- !.
d(C, _, 0) :- atomic(C), !.

% built-in functions
d(sin(T), T, cos(T)) :- !.
d(cos(T), T, -sin(T)) :- !.
d(tan(T), T, 1/(cos(T))^2) :- !.
d(log(T), T, 1/T) :- !.
d(exp(T), T, exp(T)) :- !.
d(atan(T), T,  1/(1+T^2)) :- !.
d(acos(T), T, -1/(1-T^2)^0.5) :- !.
d(asin(T), T, 1/(1-T^2)^0.5) :- !.

% Chain rule
d(F_G, T, DF*DG) :- F_G =.. [_ , G], !, d(F_G, G, DF), d(G, T, DG).



