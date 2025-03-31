power :: Int -> Int -> Int
power n 0 = 1
power n p = power n (p - 1) * n