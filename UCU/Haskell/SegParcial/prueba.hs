import Data.Maybe (listToMaybe, fromJust, maybeToList)

class Arborescent t where
  nodeValue :: (t a) -> Maybe a
  nodeChildren :: (t a) -> [t a]
  isNodeEmpty :: (t a) -> Bool
  isNodeEmpty t = null (nodeChildren t)
--Una posible instancia podría ser para el tipo BinTree, que representa árboles binarios, de la siguiente forma:

data BinTree a = TreeNode a (BinTree a) (BinTree a)
   | EmptyTree deriving (Eq, Show)
  
instance (Arborescent BinTree) where
  nodeValue EmptyTree = Nothing
  nodeValue (TreeNode v _ _) = Just v
  nodeChildren EmptyTree = []
  nodeChildren (TreeNode _ lt rt) = [lt, rt]

a = TreeNode 4 (TreeNode 9 (TreeNode 16 EmptyTree EmptyTree) EmptyTree) (TreeNode 4 (TreeNode 2 EmptyTree EmptyTree) EmptyTree)

bfs :: (Arborescent t) => (t a) -> (a -> Bool) -> Maybe a
bfs t f = listToMaybe (filter f (map (\x -> fromJust (nodeValue x)) (treeToList [t]))) 

treeToList :: (Arborescent t) => [(t a)] -> [(t a)]
treeToList [] = []
treeToList (t:ts) = t : treeToList (ts ++ nodeChildren t)

sacarMaybe :: Maybe a -> a
sacarMaybe (Just a) = a
sacarMaybe Nothing = error "Lol"
-------------------------------------------------------------------------------------

mapBinTree :: (Ord a) => (BinTree a) -> (a -> Bool) -> (BinTree a)
mapBinTree t f =  initTree (filter (\x -> f x == True) (preorder t)) 

initTree :: (Ord a) => [a] -> BinTree a
initTree as = foldl (\t v -> treeInsert v t) EmptyTree as

treeInsert :: (Ord a) => a -> BinTree a -> BinTree a
treeInsert x EmptyTree = TreeNode x EmptyTree EmptyTree
treeInsert x (TreeNode a left right)
    | x == a = TreeNode x left right
    | x < a  = TreeNode a (treeInsert x left) right
    | x > a  = TreeNode a left (treeInsert x right)

preorder :: (Arborescent t) => (t a) -> [a]
preorder t
    | isNodeEmpty t = []
    | otherwise = maybeToList (nodeValue t) ++ concat (map preorder (nodeChildren t))




data PlayingCard n = Clubs n | Diamonds n | Hearts n | Spades n | Joker deriving (Show, Eq)