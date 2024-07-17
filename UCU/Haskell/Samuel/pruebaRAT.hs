import Data.Char

data HijaraAction = HijaraAction Int Int deriving (Eq, Show) -- row, column

unaact = HijaraAction 1 0

showAction :: HijaraAction -> String
showAction (HijaraAction r c) = ("ABCD" !! c): (show r)

