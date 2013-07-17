% Prolog - Some exercises on lists
% Texts from the "Learn Prolog Now" book
% Marcello Pogliani <marcello.pogliani@gmail.com>

%E1. append/3: append two lists

append([], L, L) :- !.
append([H|T1], B, [H|T2]) :- append(T1, B, T2).

% E2. reverse/2: Reverse a list
% First version, with append

nreverse([], []).
nreverse([H|T], X) :- nreverse(T, Y), append(Y, [H], X).

% Second version, using accumulator
reverse(L, X) :- reverseaux(L, [], X).
reverseaux([], X, X).
reverseaux([H|T], W, X) :- reverseaux(T, [H|W], X).

% E3. Some exercises using reverse and append.
% 6.1) doubled succeeds if List is a doubled list
doubled(List) :- append(X, X, List).

% 6.2) palindrome succeeds if a word is palindrome
palindrome(Word) :- reverse(Word, Word).

% 6.3) toptail
toptail([_|T], Out) :- append(Out,[_],T).

% 6.4) last using reverse and recursive def.
lastrev(List, X) :- reverse(List, [X|_]).

last([X|[]], X) :- !.
last([_|T], X) :- last(T,X).

% 6.5) swapf(List1, List2)

swapf([X|L1], [Y|L2]) :- 
		swapfrec(X, Y, L1, L2, [], []).
swapfrec(X, Y, [Y], [X], _, _) :- !.
swapfrec(X, Y, [H1|T1], [H2|T2], A1, A2) :-
		H1 = H2,
		swapfrec(X, Y, T1, T2, [H1 | A1], [H2 | A2]).

% P6.1) member using append/3
mymember(List, X) :- 
		append(_,[X|_],List). 

% P6.2) remove duplicates from a list (what a strange order)
set([], []) :- !.
set([H|List], Set) :-
		member(H, List), !,
		set(List, Set).
set([H|List], [H|Set]) :-
		set(List, Set).

% P6.3) flatten a list (using append/3)

flatten(List, Out) :- flatten(List, [], Out).

flatten([], Acc, Acc) :- !.
flatten(Atom, Acc, [Atom|Acc]) :- 
		atomic(Atom).
flatten([Head|Tail], Acc, Out) :- 
		flatten(Head, X, Out),
		flatten(Tail, Acc, X).

% 5.3) addone/2 add 1 to each element of the list
addone([], []) :- !.
addone([H|List], [X|Out]) :- 
		X is H + 1, addone(List, Out).

% P5.2) scalar mult
scalarMult(_, [], []) :- !.
scalarMult(N, [Head|Tail], [X|Out]) :- 
		X is N * Head, 
		scalarMult(N, Tail, Out).

% P5.3) dot product: dot([2,5,6], [3,4,1], Result) yield Result = 32
dot([], [], 0) :- !.
dot([H1|T1], [H2|T2], R) :- 
		dot(T1, T2, X), R is X + H1*H2.

