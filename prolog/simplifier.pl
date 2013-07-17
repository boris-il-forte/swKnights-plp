%% Simplifier

% simplify main routine
simplify(_^0, 1) :- !.
simplify(X^1, X) :- !.
simplify(X,Y) :- term(X, 0, R, S), !, algebricSum(S, R, Y).

% simplify factors
factor(X, N, 1, P) :- integer(X), !, P is X*N.
factor(X, N, X, N) :- atomic(X), !.
factor(X^Y, N, X^Y, N) :- atomic(X).
factor(X*Y, N, Z, R) :- factor(X, N, A1, P), factor(Y, P, A2, R), !, algebricProd(A1, A2, Z).
factor(X/Y, N, Z, R) :- factor(Y, 1, A2, Q), P is N/Q, factor(X, P, A1, R), !, algebricDiv(A1, A2, Z). 

% simplify terms
term(X, N, Y, N) :- factor(X, 1, R, P), !, algebricProd(P, R, Y).
term(X+Y, N, Z, S) :- term(X, N, A1, R), term(Y, R, A2, S), !, algebricSum(A1, A2, Z).
term(X-Y, N, Z, S) :- term(X, N, A1, R1), term(Y, 0, A2, R2), !, algebricSub(A1, A2, Z), S is R1-R2.


%product
algebricProd(0, _, 0) :- !.
algebricProd(_, 0, 0) :- !.
algebricProd(1, A, Z) :- !, Z = A.
algebricProd(A, 1, Z) :- !, Z = A.
algebricProd(1.0, A, Z) :- !, Z = A.
algebricProd(A, 1.0, Z) :- !, Z = A.
algebricProd(A, A, A^2) :- !.
algebricProd(A^N, A, A^K) :- integer(N), !, K is N+1.
algebricProd(A, A^N, A^K) :- integer(N), !, K is N+1.
algebricProd(A^M, A^N, A^K) :- integer(M), integer(N), !, K is M+N.
algebricProd(A1, A2, Z) :- !, Z = A1*A2.

% division
algebricDiv(0, _, 0) :- !.
algebricDiv(A, 1, Z) :- !, Z = A.
algebricDiv(A, 1.0, Z) :- !, Z = A.
algebricDiv(A, A, 1) :- !.
algebricDiv(A^N, A, A^K) :- integer(N), !, K is N-1.
algebricDiv(A, A^N, A^K) :- integer(N), !, K is N-1.
algebricDiv(A^M, A^N, A^K) :- integer(M), integer(N), !, K is M-N.
algebricDiv(A1, A2, Z) :- !, Z = A1/A2.

% sum
algebricSum(0, X, X) :- !.
algebricSum(X, 0, X) :- !.
algebricSum(X, X, Y) :- !, algebricProd(2,X, Y).
algebricSum(N*A, A,Y) :- integer(N), !, K is N+1, algebricProd(K, A, Y).
algebricSum(A, N*A, Y) :- integer(N), !, K is N+1, algebricProd(K, A, Y).
algebricSum(M*A, N*A, Y) :- integer(M), integer(N), !, K is M+N , algebricProd(K, A, Y).
algebricSum(X, Y, Z) :- !, Z = X+Y.

% subtraction
algebricSub(0, X, -X) :- !.
algebricSub(X, 0, X) :- !.
algebricSub(X, X, 0) :- !.
algebricSub(N*A, A,Y) :- integer(N), !, K is N-1, algebricProd(K, A, Y).
algebricSub(A, N*A, Y) :- integer(N), !, K is 1-N, algebricProd(K, A, Y).
algebricSub(M*A, N*A, Y) :- integer(M), integer(N), !, K is M-N , algebricProd(K, A, Y).
algebricSub(X, Y, Z) :- !, Z = X-Y.


