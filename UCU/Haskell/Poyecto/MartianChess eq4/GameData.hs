module GameData where

import Util
import Data.List (intercalate, lines)

data MartianChessPlayer = DeimosPlayer | PhobosPlayer deriving (Eq, Enum, Bounded)
data MartianChessGame = Playing MartianChessPlayer Board Score MartianChessConfig | Finished (GameResult MartianChessPlayer) deriving (Eq, Show)
data MartianChessAction = Move Piece (Int, Int) (Int, Int) | Eat Piece (Int, Int) Piece (Int, Int) deriving (Eq, Show)
data GameResult p = Winner p | Loser p | Draw deriving (Eq, Show)

data Piece = Empty | Pawn | Drone | Queen deriving (Eq, Enum, Bounded)
data Board = Board [[Piece]] deriving (Eq)
data Score = Score [(MartianChessPlayer, Int)] deriving (Eq)

data MartianChessConfig = MartianChessConfig {
    points :: [Int],
    maxRounds :: Int,
    rampedScores :: Bool
} deriving (Eq, Show)

instance (Show Piece) where
    show Empty = "."
    show Pawn = "P"
    show Drone = "D"
    show Queen = "Q"

instance (Show Board) where
    show (Board brd) = intercalate "\n  " (concat (["x\\y"] : [lines (showMatrix zone) | zone <- [take 4 brd, drop 4 brd]]))

instance (Show Score) where
    show (Score scr) = intercalate " | " (map ((\(player, points) -> intercalate ": " [show player, show points])) scr)

instance (Show MartianChessPlayer) where
    show PhobosPlayer = "Phobos"
    show DeimosPlayer = "Deimos"

showResult :: GameResult MartianChessPlayer -> String
showResult (Winner plyr) = "The Winner is " ++ show plyr ++ "!"
showResult (Loser plyr) = show plyr ++ " losed..."
showResult Draw = "Its a tie!"

initialBoard :: Board
initialBoard = Board ([[Queen, Queen, Drone, Empty],
                [Queen, Drone, Pawn, Empty],
                [Drone, Pawn, Pawn, Empty],
                [Empty,Empty,Empty,Empty],
                [Empty,Empty,Empty,Empty],
                [Empty, Pawn, Pawn, Drone],
                [Empty, Pawn, Drone, Queen],
                [Empty, Drone, Queen, Queen]])

initialScore :: Score
initialScore = Score (map (\p -> (p, 0)) players)

players :: [MartianChessPlayer]
players = [minBound..maxBound]

readPiece :: String -> Piece
readPiece pieceStr 
    | pieceStr == "P" = Pawn
    | pieceStr == "D" = Drone
    | pieceStr == "Q" = Queen
    | pieceStr == "." = Empty
    | otherwise = error ("Unknown piece " ++ pieceStr)
