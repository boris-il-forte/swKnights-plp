module MonadicVector where

-- Defining a proper type for the monad
newtype MVector a b = MVector ((Int -> a) -> ((Int->a), b))

-- defining show for the monad... shows the value, not the vector
instance Show b => Show(MVector a b) where
	show (MVector x) = let (t,s) = x t in show s

-- The monad implementation: very similar to state monad...
instance Monad (MVector vector) where
	return x = let f t = (t,x)
		   in MVector f
	
	MVector f >>= g = MVector(\oldvector -> 
			   let (newvector, val) = f oldvector 
			       MVector f'        = g val
			   in f' newvector)

-- initialize vector with a vector with policy described in the function f
createVector f = MVector (\oldvector -> (emptyVector , ())) where
	emptyVector n = f n
	
-- initialize vector with a vector of zeros
createZeroVector = createVector (\n -> 0)

-- initialize vector with a failing vector not working...
-- createFailingVector :: MVector a ()
-- createFailingVector = createVector(\n -> let s ="the index" ++ (show n) ++ "is undefined" in s >>=  fail s)

-- get a value from the vector
getValue i 
	| i >= 0  = MVector(\vector -> (vector, vector i))
	| otherwise = fail "negative index"

-- put a value in the vector 
putValue (new, i)  
	| i > 0 = MVector (\oldvector -> (newvector oldvector , ())) 
	| otherwise = fail "negative index"
	where
		newvector oldvector n
			| n == i = new
			| otherwise = oldvector n

-- Test code
main = 	do
	{
		createZeroVector;
		putValue(5,4);
		x <- getValue(4);
		y <- getValue(0);
		putValue(x,6);
		z <- getValue(6);
		return (x+y+z);
		
	}
