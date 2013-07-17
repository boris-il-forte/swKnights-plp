% operator precedence
precedes(^, _).
precedes(*, O) :- (O = +; O = -; O = *; O = /).
precedes(/, O) :- (O = +; O = -; O = *; O = /).
precedes(+, O) :- (O = + ; O = -).
precedes(-, O) :- (O = + ; O = -).






