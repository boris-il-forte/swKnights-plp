killer(butch).
married(mia, marsellus).
dead(zed).

kills(marsellus, X) :- footMassage(X, mia).
loves(mia, X) :- goodDancer(X).
eats(jules, X) :- nutritious(X) ; tasty(X).

footMassage(claudio, mia).

goodDancer(laura).

wizard(ron).
wizard(X) :- hasBroom(X),  hasWand(X). 

hasWand(harry). 
quidditchPlayer(harry). 
  
hasBroom(X) :- quidditchPlayer(X).

