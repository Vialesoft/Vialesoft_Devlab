import Data.Maybe (listToMaybe)

toHour :: Int -> Int -> Double -> Double
toHour h m s = ((s / 60.0 + (fromIntegral m)) / 60.0 + (fromIntegral h)) / 24.0

fromHour :: Double -> (Int, Int, Double)
fromHour n = (h, m, s)
  where h = floor (n * 24)
        m = floor ((n * 24 - (fromIntegral h)) * 60)
        s = ((n * 24 - (fromIntegral h)) * 60 - (fromIntegral m)) * 60

data Hour = Hour3 Int Int Double
    | Hour1 Double deriving (Eq, Ord, Show)

hour1, hour3 :: Hour -> Hour
hour1 (Hour3 h m s) = Hour1 (toHour h m s)
hour1 x = x
hour3 (Hour1 n) = Hour3 h m s
    where (h, m, s) = fromHour n
hour3 x = x

schedule :: Hour -> Hour -> Integer -> [Hour]
schedule h0 hf f = map hour3 (map Hour1 (takeWhile (<= nf) (iterate (+ inc) n0)))
  where (Hour1 n0) = hour1 h0
        (Hour1 nf) = hour1 hf
        inc = ((fromInteger f) / 24.0 / 60.0)




data Schedule = Schedule Hour Hour Integer deriving (Eq, Show)

nextHour :: Schedule -> Hour -> Maybe Hour
nextHour (Schedule h0 hf f) hx = listToMaybe (map hour3 nexts) 
  where (Hour1 nx) = hour1 hx
        schedule1 = map hour1 (schedule h0 hf f)
        nexts = dropWhile (\(Hour1 n) -> n < nx) schedule1