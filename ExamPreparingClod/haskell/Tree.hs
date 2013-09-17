module Tree (Tree, leaf, branch, cell, left, right, isLeaf, fringe ) where

data Tree a = Leaf a | Branch (Tree a) (Tree a)

fringe :: Tree a -> [a]
fringe (Leaf x) = [x]
fringe (Branch left right) = fringe left ++ fringe right

leaf = Leaf
branch = Branch
cell (Leaf a) = a
left (Branch l r) = l
right (Branch r l) = r
isLeaf (Leaf _) = True
isLeaf _ = False


