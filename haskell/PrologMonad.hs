module PrologMonad where

--  tentativo di implementare il backtracking del prolog in haskell...ovviamente non riuscito.

-- todo: tipo sbagliato! fatto casino...
type ContAndWays w a r = ((a -> r), [w])
newtype MProlog w a r = MProlog { runningContAndWays :: (ContAndWays w a r -> (ContAndWays w a r , r)) } -- r is the final result type of the whole computation 

instance Show r => Show (MProlog r w a) where
	show (MProlog x) = let (cw, r) = x cw in show r

instance Monad (MProlog _ w a) where 
	return x = MProlog $ \k -> (k, x)
	
	(MProlog f) >>= g = MProlog $ \k -> 
		let
		{
			(cont, ways) = k;
			newcont = \a -> let ((c, w), r) = (runningContAndWays(g a)) k in c a
		}
		in f (newcont, ways)
		
try (x:xs) = MProlog $ \k -> let (c, xs) = k in  c x
try [] = fail "No options left"
failC = MProlog $ \k -> let (c, x:xs) = k in  c x 
			    
main = do
	{
		x <- try [1,2,3];
		if x == 3 then return x
		else failC 
	}


