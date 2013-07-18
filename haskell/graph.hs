module Graph where

data Graph a = Graph [Node a]
data Node a = Node {nodeName::String, nodeData::a, successors::[Node a]}

getNames [] = "∅;"
getNames [x] = nodeName x ++ ";"
getNames (x:xs) = nodeName x ++ ", " ++ getNames xs

instance Eq a => Eq (Node a) where
	a == b = nodeName a == nodeName b

instance Show a => Show (Graph a) where
	show (Graph (h:t)) = "Graph: {" ++ show h ++ showRest t ++ "}" where
		showRest [] = ""
		showRest (h:t) = " | " ++ show h ++ showRest t

instance Show a => Show (Node a) where
	show n = nodeName n ++ "(" ++ show(nodeData n) ++ "): " ++  (getNames $ successors n)
	

breadthFirst (Graph (h:_)) = breadthFirst' [h] [] where
	breadthFirst' [] visited = visited
	breadthFirst' (current:toVisit) visited  = 
		let
		{
			visited' = visited ++ [current];
			sons = getNewSuccessors current visited';
		} 
		in breadthFirst' (toVisit ++ sons) visited' where
			getNewSuccessors node blackList = [ x | x <- successors(node) ,  not(x `elem` blackList)]

test = let 
{	test = Graph [x,y,z,w];
	x = Node "a" 1 [x, y, z];
	y = Node "b" 2 [y, z];
	z = Node "c" 3 [w];
	w = Node "d" 4 [];
} in test

