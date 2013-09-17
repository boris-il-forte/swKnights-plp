module Main where

newtype State st a = State (st -> (st, a))

instance Monad (State state) where
	return x = let f t = (t,x)
		   in State f
	
	State f >>= g = State (\oldstate ->
				let (newstate, val) = f oldstate
				    State f'	    = g val
				in f' newstate)

esm :: State Int Int
esm = return (5) >>= \x -> return (x+1)

getState :: State state state
getState = State (\state -> (state, state))

putState :: state -> State state ()
putState new = State (\_ -> (new, ()))

esm' :: State Int Int
esm' = do x <- getState
	  return (x+1) 

esm'' :: State Int Int
esm'' = getState >>= (\x -> putState(x+1) >>= (\_ -> getState >>= (\x -> return x)))

esm''' :: State Int Int
esm''' = do x <- getState
	    putState(x+1)
	    x <- getState
	    return (x+x)
data Tree a = Leaf a | Branch (Tree a) (Tree a) deriving Show

mapTreeM :: (a -> State state b) -> Tree a -> State state (Tree b)
mapTreeM f (Leaf a) = do
	b <- f a
	return (Leaf b)
mapTreeM f (Branch lhs rhs) = do
	lhs' <- mapTreeM f lhs
	rhs' <- mapTreeM f rhs
	return (Branch lhs' rhs')

runStateM :: State state a -> state -> (state, a)
runStateM (State f) st = f st

numberTree :: Tree a -> State Int (Tree (a, Int))
numberTree tree = mapTreeM number tree
	where number v  = do
		cur <- getState
		putState (cur+1)
		return (v, cur)

testTree = Branch (Branch
			(Leaf 'a')
			(Branch
				(Leaf 'b')
				(Leaf 'c')))
			(Branch
				(Leaf 'd')
				(Leaf 'e'))



main::IO()
main = print (runStateM (numberTree testTree) 1)
