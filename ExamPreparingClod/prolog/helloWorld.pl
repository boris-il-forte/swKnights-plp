find([X|_],X).
find([Y|L], X) :- find(L, X).



