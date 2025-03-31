isPrime :: Int -> Bool
isPrime x
    | (x == 0) || (x == 1) = False
    | even x = False
    | otherwise = not (hasDivisor x (x-1))

hasDivisor :: Int -> Int -> Bool
hasDivisor _ 1 = False
hasDivisor x n = (mod x n == 0) || hasDivisor x (n-1)
