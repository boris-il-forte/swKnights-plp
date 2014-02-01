% Write a 3-place predicate combine1 which takes three lists as 
% arguments and combines the elements of the first two lists into 
% the third as follows:

%   ?-  combine1([a,b,c],[1,2,3],X).    
%  X  =  [a,1,b,2,c,3] 

combine1([],[],[]).
combine1([H1|T1], [H2|T2], [H1,H2|T3]) :- combine(T1, T2, T3).

% Now write a 3-place predicate combine2 which takes three lists as % arguments and combines the elements of the first two lists into 
% the third as follows:
%   ?-  combine2([a,b,c],[1,2,3],X). 
    
%   X  =  [[a,1],[b,2],[c,3]] 
    
%   ?-  combine2([f,b,yip,yup],[glu,gla,gli,glo],Result). 

combine2([],[],[]).
combine2([H1|T1], [H2|T2], [[H1,H2]|T3]) :- combine2(T1, T2, T3).


% Finally, write a 3-place predicate combine3 which takes three 
% lists as arguments and combines the elements of the first two 
% lists into the third as follows:
%   ?-  combine3([a,b,c],[1,2,3],X). 
    
%   X  =  [j(a,1),j(b,2),j(c,3)




