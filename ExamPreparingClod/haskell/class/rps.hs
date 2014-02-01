module Main where

data RPS = Paper | Shissor | Rock deriving (Show, Eq)

instance Ord RPS where
	Paper   <=   Shissor     = True
	Shissor <=   Rock 	 = True
	Rock 	<=   Paper       = True
	_	<=   _		 = False

main::IO()
main = undefined
