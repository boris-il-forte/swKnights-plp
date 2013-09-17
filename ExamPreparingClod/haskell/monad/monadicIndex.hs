module Main where


newtype State st a = State (st -> (st, a))

instance Monad (State state) where
	return x = let f t = (t,x)
		in State f
	State f >>= g = State (\oldstate ->
				let (newstate, val) = f oldstate
					State f'    =  g val
				in f' newstate)

getState :: State state state
getState = State (\state -> (state, state))
putState :: state -> State state ()
putState new = State (\_ -> (new, ()))
	
esm :: State Int Int
esm = do x <- return 5
		return (x+1)




main::IO()
main = print (let State f = esm in (f 333))
