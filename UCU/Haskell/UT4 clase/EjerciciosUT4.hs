import Data.List

data BinTree a = TreeNode a (BinTree a) (BinTree a)
   | EmptyTree deriving (Eq, Show)

class Arborescent t where
  nodeValue :: (t a) -> Maybe a
  nodeChildren :: (t a) -> [t a]
  isNodeEmpty :: (t a) -> Bool
  isNodeEmpty t = null (nodeChildren t)

instance Arborescent BinTree where
    nodeValue EmptyTree = Nothing
    nodeValue (TreeNode v _ _) = Just v
    nodeChildren EmptyTree = []
    nodeChildren (TreeNode _ EmptyTree EmptyTree) = []
    nodeChildren (TreeNode _ hijoIzq EmptyTree) = [hijoIzq]
    nodeChildren (TreeNode _ EmptyTree hijoDer) = [hijoDer]
    nodeChildren (TreeNode _ hijoIzq hijoDer) = [hijoIzq, hijoDer]

-- height :: (Arborescent t) => (t a) -> Int
-- height t
--   | isNodeEmpty t = 0
--   | otherwise = 1 + (maximum (map height (nodeChildren t)))

-- preorder :: (Arborescent t) => (t a) -> [a]
-- preorder t
--     | isNodeEmpty t = []
--     | otherwise = [(sacarMaybe (nodeValue t))] ++ (preorder (children !! 0)) ++ (preorder (children !! 1))
--         where children = nodeChildren t

sacarMaybe :: Maybe a -> a
sacarMaybe (Just a) = a
sacarMaybe Nothing = error "Lol"

-- posorder :: (Arborescent t) => (t a) -> [a]
-- posorder t
--     | isNodeEmpty t = []
--     | otherwise = (posorder (children !! 0)) ++ (posorder (children !! 1)) ++ [(sacarMaybe (nodeValue t))]
--         where children = nodeChildren t

inorder :: (Arborescent t) => (t a) -> [a]
inorder t
    | isNodeEmpty t = []
    | otherwise = (inorder (children !! 0)) ++ [(sacarMaybe (nodeValue t))] ++ (inorder (children !! 1))
        where children = nodeChildren t

fromPreorder :: [a] -> BinTree a
fromPreorder [] = EmptyTree
fromPreorder (x:xs) = TreeNode x leftChild rightChild
  where n = div (length xs) 2
        leftChild = fromPreorder (take n xs)
        rightChild = fromPreorder (drop n xs)


-- Parcial
data NTree a = NTreeNode a [NTree a]
  | EmptyNTree deriving (Eq, Show)

instance Arborescent NTree where
    nodeValue EmptyNTree = Nothing
    nodeValue (NTreeNode v _) = Just v
    nodeChildren EmptyNTree = []
    nodeChildren (NTreeNode _ hijos) = hijos

height :: (Arborescent t) => (t a) -> Int
height t
  | isNodeEmpty t = 0
  | otherwise = 1 + (maximum (map height (nodeChildren t)))

preorder :: (Arborescent t) => (t a) -> [a]
preorder t
    | isNodeEmpty t = []
    | otherwise = [(sacarMaybe (nodeValue t))] ++ concat (map preorder children)
        where children = nodeChildren t

posorder :: (Arborescent t) => (t a) -> [a]
posorder t
  | isNodeEmpty t = []
  | otherwise = concat (map posorder children) ++ [(sacarMaybe (nodeValue t))]
    where children = nodeChildren t
  

--Función que arma un árbol a partir de una lista de tuplas de la forma (valor, [lista de valores])


indentedTree :: (Arborescent t, Show a) => (t a) -> String
indentedTree t = _indentedTree t 0 
  
spaces2n :: Int -> String
spaces2n n = (take (2 * n) (repeat ' '))

_indentedTree :: (Arborescent t, Show a) => (t a) -> Int -> String
_indentedTree t n = '\n':(spaces2n n) ++ (show (nodeValue t)) ++ (
  concat [_indentedTree c (n + 1) | c <- nodeChildren t])


data GeneratedTree a = GeneratedTree a (a -> [a])

instance (Arborescent GeneratedTree) where
  nodeValue (GeneratedTree v _) = Just v
  nodeChildren (GeneratedTree v f) = [GeneratedTree x f | x <- f v]

sameDiagonal :: (Int, Int) -> (Int, Int) -> Bool
sameDiagonal (x1,y1) (x2,y2) = abs (y1 - y2) /= abs (x1 - x2)

valid8Queens :: [Int] -> Bool
valid8Queens cs = sort cs == [1..8] && (or [sameDiagonal (i, cs !! i) (j, cs !! j) | i <- [0..7], j <- [(i + 1)..7]])

search8Queens = filter valid8Queens $ preorder searchTree
  where childs xs = [x:xs | x <- [1..8] \\ xs]
        searchTree = GeneratedTree [] childs


--data Either a b = Left a | Right b

fun :: Either a a -> a
fun (Left a) = a
fun (Right b) = b

