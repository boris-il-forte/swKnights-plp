concatenate([X|L1],L2, [X|L3]) :- concatenate(L1,L2,L3).
concatenate([],L,L).
