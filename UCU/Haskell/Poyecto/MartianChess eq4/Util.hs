module Util where

import Data.List (intercalate)

line :: Int -> String
line len = concat $ take len $ repeat "-"

showMatrix :: (Show a) => [[a]] -> String
showMatrix mtrx = joinLn [line len, intercalate ("\n" ++ line len ++ "\n") (map showRow mtrx), line len]
    where len = length (showRow (head mtrx))

insertMatrix :: [[a]] -> a  -> (Int, Int) -> [[a]]
insertMatrix [] _ _ = []
insertMatrix mtrx _ (x,y) | length mtrx < x || length (head mtrx) < y = error "Invalid index"
insertMatrix mtrx obj (x,y) = take x mtrx ++ [take y row ++ [obj] ++ drop (y+1) row] ++ drop (x+1) mtrx
    where row = mtrx !! x

showRow :: (Show a) => [a] -> String
showRow row = "| " ++ intercalate " | " (map show row) ++ " |"

joinLn :: [String] -> String
joinLn strs = intercalate "\n" strs