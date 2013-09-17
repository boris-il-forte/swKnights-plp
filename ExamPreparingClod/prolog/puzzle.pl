word(ahtante,  a,h,t,a,n,t,e). 
word(astoria,  a,s,t,o,r,i,a). 
word(baratto,  b,a,r,a,t,t,o). 
word(cobalto,  c,o,b,a,l,t,o). 
word(pistola,  p,i,s,t,o,l,a). 
word(statale,  s,t,a,t,a,l,e).


crossword(H1, H2, H3, V1, V2, V3) :- 
	word(H1, _, I11, _, I12, _, I13, _),
	word(H2, _, I21, _, I22, _, I23, _),
	word(H3, _, I31, _, I32, _, I33, _),
	word(V1, _, I11, _, I21, _, I31, _),
	word(V2, _, I12, _, I22, _, I32, _),
	word(V3, _, I13, _, I23, _, I33, _),
	different([H1, H2, H3, V1, V2, V3]).

different([]).
different([A|B]) :- not(member(A,B)), different(B).


