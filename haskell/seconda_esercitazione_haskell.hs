module Main where

--	class Monad m where
--
--		return :: a -> m a 
--	
--		(>>=) :: m a -> (a -> m b) -> m b
--	
--		(>>) :: m a -> m b -> m b
--
--		>> k = m >>=\_ -> k --default implementation

newtype State st a = State (st -> (st, a))

instance Monad	(State state) where

	return x = let f t = (t,x)
		   in State f
	
	State f >>= g = State(\oldstate -> 
			   let (newstate, val) = f oldstate 
			       State f'        = g val
			   in f' newstate)		

data Tree a = Leaf a | Branch (Tree a) (Tree a) deriving (Show, Eq)

mapTreeM :: (a -> State state b) -> Tree a -> State state (Tree b)
mapTreeM f (Leaf a) = 
	f a >> = (\b -> return (Leaf b))

mapTreeM f (Branch lhs rhs) = do
	lhs' <- mapTreeM f lhs
	rhs' <- mapTreeM f rhs
	return (Branch lhs' rhs')

getState :: State state state
getState = State(\state -> (state, state))

putState :: state -> State state ()
putState new = State(\_ -> (new, ()))

collectTree :. Tree b -> State [b] (Tree b)
collectTree tree = mapTreeM collectList tree
	where collectList v = do
		cur <- getState
		putState (cur ++ [v]) -- ++concatena
		return v

	
main = undefined
