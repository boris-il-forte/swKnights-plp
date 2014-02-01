module MyWriterMonad where

newtype Writer a = Writer { runWriter :: (a,String) } 
 
instance Monad (Writer) where 
    return a             = Writer (a,"") 
    (Writer (a,w)) >>= f = let (a',w') = runWriter $ f a in Writer (a',w ++ w') 
