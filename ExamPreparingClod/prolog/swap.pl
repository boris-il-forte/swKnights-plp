% 4.4 Write a predicate swap12(List1,List2) which checks whether 
% List1 is identical to List2 , except that the first two elements 
% are exchanged.

swap12([First,Second|Rest],[Second, First|Rest]).
