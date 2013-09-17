module Main where

newtype MyWriter w a = MyWriter {runMyWriter :: (a,w)}

instance Monad (MyWriter writer) where
	return x = MyWriter (x , "")




main::IO()
main = undefined
