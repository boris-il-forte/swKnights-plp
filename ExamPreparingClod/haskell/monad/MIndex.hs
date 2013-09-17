module Main where

newtype State st a = State (st -> (st, a))
  
 
instance Monad (State state) where
        return x = let f t = (t,x)
                   in State f

        State f >>= g = State (\oldstate ->
                                let (newstate, val) = f oldstate
                                    State f'        = g val
                                in f' newstate)

getState :: State state state
getState = State (\state -> (state, state))
putState :: state -> State state ()
putState new = State (\_ -> (new, ()))

runStateM :: State state a -> state -> a
runStateM (State f) st = snd (f st)

testList = [1, 5, 4, 8, 9, 11]

getIndex:: [Integer] -> Integer -> State Integer Integer
getIndex [] _ = State f where f x = (-1, -1) -- caso in cui non trovo niente
getIndex (x:xs) y 
	| x == y = do k <- getState
		      return k
	| otherwise =  do k <- getState
			  putState(k +1)
			  getIndex xs y


isIn::[Integer] -> Integer -> Integer
isIn [] _ = -1
isIn (x:xs) y 
	| x == y = y
	| otherwise = isIn xs y

main::IO()
main = print (runStateM (getIndex testList 9) 0)
