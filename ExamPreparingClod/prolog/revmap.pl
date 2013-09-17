revmap(F,[X|Y],Z,W) :- call(F, X1, X), revmap(F,Y,[X1|Z],W).
revmap(_,X,[],X).

