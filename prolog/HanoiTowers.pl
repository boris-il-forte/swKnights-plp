% ===========================
% Sudoku solver - variant of a version found on the Web,
% original author unknown


% Prerequisites



% For-All
%
% example:
%  member(X=Y, [a=b, c=d]).
%  X = a,
%  Y = b ;
%  X = c,
%  Y = d.
%
%  forall(member(X=Y, [a=b, c=d]), (atomic(X), atomic(Y))).

% ! forall implementation:
all(Cond, Action) :- \+ (Cond, \+ Action).

% es: all(member(X, [1,2,3]), X > 0).




% The standard Sudoku relation:
%
%    1 2 3 4 5 6 7 8 9
%  1
%  2   1     2     3 
%  3
%  4 
%  5   4     5     6
%  6       x
%  7  
%  8   7     8     9
%  9

related(vt(R,_), vt(R,_)).
related(vt(_,C), vt(_,C)).
related(vt(R,C), vt(R1,C1)) :- 
    A  is ((R  - 1) // 3) * 3 + ((C  - 1) // 3) + 1, 
    A1 is ((R1 - 1) // 3) * 3 + ((C1 - 1) // 3) + 1, 
    A = A1. 

%  e.g. position x is vt(6,4), area: 5
% 
% s relation is for the solution: 
% e.g. s(vt(6,4), 3)



/**
* Brute force Sudoku solver 
*
* For all vertices choose a color from 1..9, such
* that none of the related vertices have the same color.
* Grouping constraints are encoded in related(V1, V2) predicate.
*/

colors(C) :- C = [1, 2, 3, 4, 5, 6, 7, 8, 9].

sudoku_solve([], _, Solution, Solution).
sudoku_solve([V | Vr], Hints, Solution, Result) :-
    member(s(V,Ch), Hints),
    sudoku_solve(Vr, Hints, [s(V,Ch) | Solution], Result).
sudoku_solve([V | Vr], Hints, Solution, Result) :-
    colors(Cols), member(C,Cols),
    forall(member(s(Vs1,Cs1), Hints),    
           (Cs1 \= C ; not(related(V, Vs1)))), 
    forall(member(s(Vs2,Cs2), Solution), 
           (Cs2 \= C ; not(related(V, Vs2)))),
    sudoku_solve(Vr, Hints, [s(V,C) | Solution], Result). 



% let us try the algorithm

% define board
% i.e. double loop on 1..9 
board(B) :-
    colors(C),
    def_row_board(C, C, [], B).

% loop on the first argument (i.e. row)
def_row_board([], _, S, S).
def_row_board([R | Rs], C, B, S) :-
    def_col_board(R, C, B, S1),
    def_row_board(Rs, C, S1, S).

% loop on the second argument (i.e. column)
def_col_board(_, [], S, S).
def_col_board(R, [C | Cs], B, S) :-
    def_col_board(R, Cs, [vt(R, C) | B], S).



% hints from image example (from Wikipedia)
hints(H) :- H = [s(vt(1,1), 5), s(vt(1,2), 3), s(vt(1,5), 7),
                 s(vt(2,1), 6), s(vt(2,4), 1), s(vt(2,5), 9),
                 s(vt(2,6), 5), s(vt(3,2), 9), s(vt(3,3), 8),
                 s(vt(3,8), 6), s(vt(4,1), 8), s(vt(4,5), 6),
                 s(vt(4,9), 3), s(vt(5,1), 4), s(vt(5,4), 8),
                 s(vt(5,6), 3), s(vt(5,9), 1), s(vt(6,1), 7),
                 s(vt(6,5), 2), s(vt(6,9), 6), s(vt(7,2), 6),
                 s(vt(7,7), 2), s(vt(7,8), 8), s(vt(8,4), 4),
                 s(vt(8,5), 1), s(vt(8,6), 9), s(vt(8,9), 5),
                 s(vt(9,5), 8), s(vt(9,8), 7), s(vt(9,9), 9)].

testsudo :-
    board(B), 
    hints(H),
    sudoku_solve(B, H, [], S),
    print(S).
