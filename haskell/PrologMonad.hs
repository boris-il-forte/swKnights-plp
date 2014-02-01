module PrologMonad where

--  tentativo di implementare il backtracking del prolog in haskell...ovviamente non riuscito.

type ContAndWays a w r = ((a -> r), [w])
newtype MProlog a w r = MProlog { runCont :: (ContAndWays a w r -> (ContAndWays a w r, r)) } -- r is the final result type of the whole computation 

instance Show r => Show (MProlog a w r) where
	show (MProlog x) = let (cw, r) = x cw in show r

instance Monad (MProlog a w) where 
	return x = MProlog $ \k -> (k, x)
	
	MProlog f >>= g = MProlog $ \k -> let
					{
						((c1,w1), r1) = f k;
						((c2, w2), r2) = g r1;
						MProlog f' = ((c1 . c2, w1), r2)
					} in f' (c2,w2)


-- newtype Cont r a = Cont { runCont :: ((a -> r) -> r) } -- r is the final result type of the whole computation 
--  
-- instance Monad (Cont r) where 
--     return a       = Cont $ \k -> k a                       
--     (Cont f) >>= g = Cont $ \k -> f (\a -> runCont (g a) k) -- i.e. f >>= g = \k -> f (\a -> g a k)