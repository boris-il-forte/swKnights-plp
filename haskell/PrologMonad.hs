module PrologMonad where

--  tentativo di implementare il backtracking del prolog in haskell...ovviamente non riuscito. Non rieco a implementare fail correttamente...

type ContAndWays r w a = ((a -> r), [w])
newtype MProlog r w a = MProlog { runningContAndWays :: (ContAndWays r w a -> r) } -- r is the final result type of the whole computation 
 
instance Monad (MProlog r w) where 
	return x = MProlog $ \k -> let (c, w) = k in  c x 
	
	(MProlog f) >>= g = MProlog $ \k -> 
		let
		{
			(cont, ways) = k;
			newcont = \a -> (runningContAndWays(g a)) k
		}
		in f (newcont, ways)
		
	fail s = do
		{
			w:ws <- getWays;
			c <- getCont;
			putContAndWays (c, ws);
			callCont s c ws;
		} where
			callCont s c [] = s
			callCont _ c w = (c w)
	 
getWays = MProlog(\k -> let (c,w) = k in (c, w, w))
getCont = MProlog(\k -> let (c,w) = k in (c, w, c))    
putContAndWays (c, w) = MProlog(\_ -> (c, w, ()))
		
		


