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
			sons = [x | x <- successors(current) ,  not(x `elem` visited')];
			toVisit' = [x | x <- (toVisit ++ sons) , not(x `elem` visited')];
		} 
		in breadthFirst' toVisit' visited'

deepthFirst (Graph (h:_)) = deepthFirst' [h] [] where
	deepthFirst' [] visited = visited
	deepthFirst' (current:toVisit) visited 
		| not(current `elem` visited) = 
			let 
			{
				visited' = deepthFirst' (successors current) (visited ++ [current]);
				toVisit' = [x | x <- toVisit, not(x `elem` visited')];
			}
			in deepthFirst' toVisit' visited'
		| otherwise  = deepthFirst' toVisit visited

visitGraph graph fvisit = let visited = fvisit graph in showNames visited where
	showNames [n] = nodeName(n) ++ ";"
	showNames (n:ns) = nodeName(n) ++ ", " ++ showNames(ns) 

buildGraph x = let nodes = buildNodes x nodes in nodes

buildNodes [] nodes = nodes
buildNodes (n:ns) nodes = 
	let 
	{
		result = newNode:nodes;
		newNode = buildNode n result
	}
	in result


buildNode  [name, dt, succNames]  nodes = Node name dt [ n | n <- nodes, nodeName(n) `elem` succNames ]



	
test = let 
{	test = Graph [a,b,c,d,e,f];
	a = Node "a" 1 [b, c];
	b = Node "b" 2 [d, e];
	c = Node "c" 3 [b, f];
	d = Node "d" 4 [];
	e = Node "e" 5 [];
	f = Node "f" 6 [a];
} in test

