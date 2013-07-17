%% Simplifier

% simplify main routine
simplify(_^0, 1) :- !.
simplify(X^1, X) :- !.
simplify(X,Y) :- factor(X, 1, R, P), !, algebricProd(P,R, Y).

% simplify factors
factor(X, N, 1, P) :- integer(X), P is X*N.
factor(X, N, X, N) :- atomic(X).
factor(X*Y, N, Z, R) :- factor(X, N, A1, P), factor(Y, P, A2, R), algebricProd(A1, A2, Z).
factor(X/Y, N, Z, R) :- factor(Y, N, A2, Q), P is 1/Q, factor(X, P, A1, R), algebricDiv(A1, A2, Z). 

%product
algebricProd(0, _, 0) :- !.
algebricProd(_, 0, 0) :- !.
algebricProd(1, A, Z) :- !, Z = A.
algebricProd(A, 1, Z) :- !, Z = A.
algebricProd(1.0, A, Z) :- !, Z = A.
algebricProd(A, 1.0, Z) :- !, Z = A.
algebricProd(A1, A2, Z) :- !, Z = A1*A2.

% division
algebricDiv(0, _, 0) :- !.
algebricDiv(A, 1, Z) :- !, Z = A.
algebricDiv(A, 1.0, Z) :- !, Z = A.
algebricDiv(A1, A2, Z) :- !, Z = A1/A2.





% simplify(X-X, 0) :- !.

% simplify(X+0, X) :- !.
% simplify(X-0, X) :- !.

%helper functions

% productuct and division
%simplify(_*0, 0) :- !.
%simplify(X*1, X) :- !.
%simplify(0+X, X) :- !.
%simplify(0-X, X) :- !.
%simplify(0*_, 0) :- !.
%simplify(1*X, X) :- !.
%simplify(X/X, 1) :- !.
%simplify(X^N*X^M, X^K) :- !, K is N+M. 
%simplify(X^N/X^M, X^K) :- !, K is N-M.