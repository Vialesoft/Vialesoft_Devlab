module MartianChessVariant where

import Data.Maybe (fromJust, listToMaybe)
import Data.List (elemIndex, sort)
import Data.Matrix
import System.Random
import System.IO.Unsafe

beginning :: MartianChessGame
beginning = MartianChessGame (fromLists [[Queen, Queen, Drone, Empty, Empty, Empty, Empty, Empty], [Queen,Drone,Pawn_,Empty,Empty,Pawn_,Pawn_,Drone], [Drone,Pawn_,Pawn_,Empty,Empty,Pawn_,Drone,Queen], [Empty,Empty,Empty,Empty,Empty,Drone,Queen,Queen]]) (Just DeimosPlayer) (0,0) 250 False

data MartianChessPlayer = DeimosPlayer | PhobosPlayer deriving (Eq, Show, Enum, Bounded)
data MartianChessGame = MartianChessGame (Matrix MartianChessSquare) (Maybe MartianChessPlayer) (Int,Int) Int Bool deriving (Eq, Show)
data MartianChessAction = MartianChessAction (Int,Int) (Int,Int) (Int) deriving (Eq, Show, Read)
data MartianChessSquare = Empty | Pawn_ | Drone | Queen | X Int | Y Int | Chess deriving (Eq, Show, Read)

_actions :: MartianChessGame -> [MartianChessAction]
_actions (MartianChessGame board player _ _ v)
  | fromJust player == DeimosPlayer = concat [getActionsByCoordinate board DeimosPlayer (x,y) v | x<-[1..4], y<-[1..4]]
  | fromJust player == PhobosPlayer = concat [getActionsByCoordinate board PhobosPlayer (x,y) v | x<-[1..4], y<-[5..8]]

getActionsByCoordinate :: (Matrix MartianChessSquare) -> MartianChessPlayer -> (Int, Int) -> Bool -> [MartianChessAction]
getActionsByCoordinate board player (x, y) v
  | board ! (x, y) == Empty = []
  | otherwise = map (\(cd, p) -> MartianChessAction (x, y) cd (p + (extraPoints p v board (x, y)))) (concat (map (\((xf, yf), (dx, dy)) -> movePieceToDestination board player (x, y) (dx, dy) (xf, yf)) (getDestinationsByPiece (board ! (x, y)) (x,y))))

extraPoints :: Int -> Bool -> (Matrix MartianChessSquare) -> (Int, Int) -> Int
extraPoints _ False _ _ = 0
extraPoints p _ _ _ | p <= 0 = 0
extraPoints _ _ board cords = 3 - (getPieceValue (board ! cords))

getDestinationsByPiece :: MartianChessSquare -> (Int, Int) -> [((Int, Int), (Int, Int))]
getDestinationsByPiece Pawn_ (x, y) = [((x + 1, y + 1), (1, 1)), ((x - 1, y - 1), ((-1), (-1))), ((x - 1, y + 1), ((-1), 1)), ((x + 1, y - 1), (1, (-1)))]
getDestinationsByPiece Drone (x, y) = [((x + 2, y), (1, 0)), ((x - 2, y), ((-1), 0)), ((x, y + 2), (0, 1)), ((x, y - 2), (0, (-1)))]
getDestinationsByPiece Queen (x, y) = [((x + 7, y),(1, 0)), ((x - 7, y),((-1, 0))), ((x, y + 7),(0, 1)), ((x, y - 7),(0, (-1))), ((x + 7, y + 7),(1, 1)),((x + 7, y - 7),(1, (-1))),((x - 7, y - 7),((-1), (-1))),((x - 7, y + 7),((-1), 1))]

movePieceToDestination :: (Matrix MartianChessSquare) -> MartianChessPlayer -> (Int, Int) -> (Int, Int) -> (Int, Int) -> [((Int, Int), Int)]
movePieceToDestination board player (xi, yi) (dx, dy) (xf, yf) 
  | xi + dx > 4 || xi + dx < 1 = []
  | yi + dy > 8 || yi + dy < 1 = []
  | board ! (xi + dx, yi + dy) == Empty && xi + dx == xf && yi + dy == yf = [((x, y), 0)]
  | player == DeimosPlayer && xi + dx == xf && yi + dy == yf = if yi + dy > 4 then [((x, y), getPieceValue (board ! (x, y)))] else []
  | player == PhobosPlayer && xi + dx == xf && yi + dy == yf = if yi + dy < 4 then [((x, y), getPieceValue (board ! (x, y)))] else [] 
  | board ! (xi + dx, yi + dy) == Empty = ((x, y), 0) : movePieceToDestination board player (x, y) (dx, dy) (xf, yf)
  | player == DeimosPlayer && board ! (xi + dx, yi + dy) /= Empty = if yi + dy > 4 then [((x, y), getPieceValue (board ! (x, y)))] else []
  | player == PhobosPlayer && board ! (xi + dx, yi + dy) /= Empty = if yi + dy < 4 then [((x, y), getPieceValue (board ! (x, y)))] else []
  where (x, y) = (xi + dx, yi + dy)

getPieceValue :: MartianChessSquare -> Int
getPieceValue Empty = 0
getPieceValue Pawn_ = 1
getPieceValue Drone = 2
getPieceValue Queen = 3

showMat :: MartianChessGame -> IO ()
showMat (MartianChessGame board _ _ _ _) = putStrLn (prettyMatrix board)

actionToString :: MartianChessGame -> MartianChessAction -> String
actionToString (MartianChessGame board player (pd, pp) _ _) (MartianChessAction ci cf p) = "Move " ++ (show (board ! ci)) ++ " from " ++ (show ci) ++ " to " ++ (show cf) ++ " for " ++ (show p) ++ " points."

_actionToString :: MartianChessAction -> String
_actionToString (MartianChessAction ci cf p) = "Move from " ++ (show ci) ++ " to " ++ (show cf) ++ " for " ++ (show p) ++ " points."

applyAction :: MartianChessGame -> MartianChessAction -> MartianChessGame
applyAction (MartianChessGame board player (pd, pp) n v) (MartianChessAction ci cf p)
  | fromJust player == DeimosPlayer = (MartianChessGame (setElem Empty ci (setElem (board ! ci) cf board)) (Just PhobosPlayer) (pd + p, pp) (n-1) v)
  | fromJust player == PhobosPlayer = (MartianChessGame (setElem Empty ci (setElem (board ! ci) cf board)) (Just DeimosPlayer) (pd, pp + p) (n-1) v)

-- showMat (applyAction beginning (MartianChessAction (1,3) (1,5) 0))
-- putStr  (unlines (map (\a -> actionToString beginning a) (_actions (beginning))))

--------------------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------------------------

data GameResult p = Winner p | Loser p | Score Int Int | MovesLeft Int| Draw deriving (Eq, Show)

activePlayer :: MartianChessGame -> Maybe MartianChessPlayer
activePlayer (MartianChessGame board player p n v)
  | n <= 0 = Nothing
  | hasFinished (MartianChessGame board player p n v) = Nothing
  | otherwise = player

actions :: MartianChessGame -> [(MartianChessPlayer, [MartianChessAction])]
actions (MartianChessGame board player p n v) = [(fromJust player, (_actions (MartianChessGame board player p n v)))]

next :: MartianChessGame -> MartianChessPlayer -> MartianChessAction -> MartianChessGame
next g _ a = applyAction g a

result :: MartianChessGame -> [GameResult MartianChessPlayer]
result (MartianChessGame board player (pd, pp) n v) 
  | pd > pp   = [Winner DeimosPlayer, Loser PhobosPlayer, Score pd pp, MovesLeft n]
  | pd < pp   = [Winner PhobosPlayer, Loser DeimosPlayer, Score pp pd, MovesLeft n]
  | otherwise = [Draw, Score pd pp, MovesLeft n]

hasFinished :: MartianChessGame -> Bool
hasFinished (MartianChessGame board _ _ _ _)
  | (length (filter (\(x, y) -> board ! (x, y) == Empty) [(x,y) | x<-[1..4], y<-[1..4]])) == 16 = True
  | (length (filter (\(x, y) -> board ! (x, y) == Empty) [(x,y) | x<-[1..4], y<-[5..8]])) == 16 = True
  | otherwise = False

showGame :: MartianChessGame -> String
showGame (MartianChessGame board player points moves variant) = (prettyMatrix (((fromLists [[X 1],[X 2],[X 3],[X 4]]) <|> board) <-> (fromLists [[Chess, Y 1, Y 2, Y 3, Y 4, Y 5, Y 6, Y 7, Y 8]]))) ++ "\r\nactive player -> " ++ (show player) ++ " points: " ++ (show points) ++ " moves left: " ++ (show moves) ++ " variant: " ++ (show variant)

showAction :: MartianChessAction -> String
showAction a = _actionToString a
   
readAction :: String -> MartianChessAction
readAction str = MartianChessAction ci cf p
  where
    p  = read (substring 35 36 str) :: Int
    ci = read (substring 16 21 str) :: (Int, Int)
    cf = read (substring 25 30 str) :: (Int, Int) 

substring :: Int -> Int -> String -> String
substring i j s = take (j-i) ( drop i s )

players :: [MartianChessPlayer]
players = [minBound..maxBound]

--------------------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------------------------

type MartianChessAgent = MartianChessGame -> IO (Maybe MartianChessAction)

{- La función ´runMatch´ corre la partida completa a partir del estado de juego dado, usando los dos 
agentes dados. Retorna una tupla con los puntajes (score) finales del juego.
-}
runMatch :: (MartianChessAgent, MartianChessAgent) -> MartianChessGame -> IO [GameResult MartianChessPlayer]
runMatch ags@(ag1, ag2) g = do
   putStrLn (showGame g)
   case (activePlayer g) of
      Nothing -> return $ result g 
      Just p -> do
         let ag = [ag1, ag2] !! (fromJust (elemIndex p players))
         move <- ag g
         runMatch ags (MartianChessVariant.next g p (fromJust move))

runGame :: (MartianChessAgent, MartianChessAgent) -> IO [GameResult MartianChessPlayer]
runGame ags = do
  -- runMatch ags beginning
  runMatch ags (beginningConfig (MartianChessConfig True)) 

{- El agente de consola ´consoleAgent´ muestra el estado de juego y los movimientos disponibles por
consola, y espera una acción por entrada de texto.
-}
consoleAgent :: MartianChessPlayer -> MartianChessAgent
consoleAgent player state = do
   let moves = fromJust (lookup player (actions state))
   if null moves then do
      putStrLn "No moves!"
      getLine
      return Nothing
   else do
      putStrLn ("Select one move:" ++ concat ["\r\n"++ (actionToString state m) | m <- moves])
      line <- getLine
      let input = readAction line
      if elem input moves then return (Just input) else do 
         putStrLn "Invalid move!"
         consoleAgent player state


{- Las funciones ´runConsoleGame´ y `runConsoleMatch` ejecutan toda la partida 
usando dos agentes de consola.
-}
runConsoleGame :: IO [GameResult MartianChessPlayer]
runConsoleGame = do
   runGame (consoleAgent DeimosPlayer, consoleAgent PhobosPlayer)
runConsoleMatch :: MartianChessGame -> IO [GameResult MartianChessPlayer]
runConsoleMatch g = do
   runMatch (consoleAgent DeimosPlayer, consoleAgent PhobosPlayer) g

{- El agente aleatorio ´randomAgent´ elige una acción de las disponibles completamente al azar.
-}
randomAgent :: MartianChessPlayer -> MartianChessAgent
randomAgent player state = do
    let moves = fromJust (lookup player (actions state))
    if null moves then do
       putStrLn "No moves!"
       return Nothing
    else do
       i <- randomRIO (0, (length moves) - 1)
       return (Just (moves !! i))

{- Las funciones ´runRandomGame´ y `runRandomMatch` ejecutan toda la partida 
usando dos agentes aleatorios.
-}
runRandomGame :: IO [GameResult MartianChessPlayer]
runRandomGame = do
   runGame (randomAgent DeimosPlayer, randomAgent PhobosPlayer)
runRandomMatch :: MartianChessGame -> IO [GameResult MartianChessPlayer]
runRandomMatch g = do
   runMatch (randomAgent DeimosPlayer, randomAgent PhobosPlayer) g

-- Fin

--------------------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------------------------

randomInteligentAgent :: MartianChessPlayer -> MartianChessAgent
randomInteligentAgent player state = do
    let moves = fromJust (lookup player (actions state))
    if null moves then do
       putStrLn "No moves!"
       return Nothing
    else do
       return (Just (getBestAction moves))

getBestAction :: [MartianChessAction] -> MartianChessAction
getBestAction as = maximum as

instance Ord MartianChessAction where
   (MartianChessAction _ _ p1) `compare` (MartianChessAction _ _ p2) = p1 `compare` p2

runRandomGameAI :: IO [GameResult MartianChessPlayer]
runRandomGameAI = do
   runGame (randomInteligentAgent DeimosPlayer, randomAgent PhobosPlayer)

runRandomGameAgainstRandom :: IO [GameResult MartianChessPlayer]
runRandomGameAgainstRandom = do
   runGame (consoleAgent DeimosPlayer, randomAgent PhobosPlayer)

runRandomGameAgainstAI :: IO [GameResult MartianChessPlayer]
runRandomGameAgainstAI = do
   runGame (consoleAgent DeimosPlayer, randomInteligentAgent PhobosPlayer)

--------------------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------------------------

type MartianChessAgentWIO = StdGen -> MartianChessGame -> MartianChessAction

-- mainWithGames (mkStdGen 1234) 10 
-- mainOnlyResults (mkStdGen 1234) 10
-- mainOnlyResults (mkStdGen 12123) 10 case with draw

mainWithGames :: StdGen -> Int -> IO ()
mainWithGames rng n = do 
    putStr (unlines (map (\(i, x) -> show i ++ " :\r\n" ++ showGame (snd x) ++ "\r\n" ++ show (fst x)) (zip [0..] res)))
    putStrLn ""
    putStr "wins: "
    putStrLn (show (length (filter (\(xs) -> (head (fst xs)) == (Winner DeimosPlayer)) res)))
    putStr "losses: "
    putStrLn (show (length (filter (\(xs) -> (head (fst xs)) == (Winner PhobosPlayer)) res)))
    putStr "draws: "
    putStrLn (show (length (filter (\(xs) -> (head (fst xs)) == (Draw)) res)))
    where
         res = (runMultipleGames rng n)

mainOnlyResults :: StdGen -> Int -> IO ()
mainOnlyResults rng n = do
    putStr (unlines (map (\(i, x) -> show i ++ " - " ++ show (fst x)) (zip [0..] res)))
    putStrLn ""
    putStr "wins: "
    putStrLn (show (length (filter (\(xs) -> (head (fst xs)) == (Winner DeimosPlayer)) res)))
    putStr "losses: "
    putStrLn (show (length (filter (\(xs) -> (head (fst xs)) == (Winner PhobosPlayer)) res)))
    putStr "draws: "
    putStrLn (show (length (filter (\(xs) -> (head (fst xs)) == (Draw)) res)))
    where
         res = (runMultipleGames rng n)

runMultipleGames :: StdGen -> Int -> [([GameResult MartianChessPlayer], MartianChessGame)]
runMultipleGames rng n 
  | n <= 0 = [] 
  | otherwise = (_runRandomGameAI rng) : (runMultipleGames (snd (System.Random.next rng)) (n - 1))

_runRandomGameAI :: StdGen -> ([GameResult MartianChessPlayer], MartianChessGame)
_runRandomGameAI rng = _runGame rng (_randomAgent, _randomInteligentAgent)

_runGame :: StdGen -> (MartianChessAgentWIO, MartianChessAgentWIO) -> ([GameResult MartianChessPlayer], MartianChessGame)
-- _runGame rng ags = _runMatch rng ags beginning
_runGame rng ags = _runMatch rng ags (beginningConfig (MartianChessConfig True))

_runMatch :: StdGen  -> (MartianChessAgentWIO, MartianChessAgentWIO) -> MartianChessGame -> ([GameResult MartianChessPlayer], MartianChessGame)
_runMatch rng ags@(ag1, ag2) g
  | activePlayer g == Nothing = ((result g), g)
  | otherwise = 
    let ag = [ag1, ag2] !! (fromJust (elemIndex (fromJust(activePlayer g)) players)) 
    in _runMatch (snd (System.Random.next rng)) ags (MartianChessVariant.next g (fromJust(activePlayer g)) (ag rng g))

_randomInteligentAgent :: MartianChessAgentWIO
_randomInteligentAgent _ state = getBestAction (_actions state) 

_randomAgent :: MartianChessAgentWIO
_randomAgent rng state = (as !! fst (randomR (0, (length as) - 1) (snd (System.Random.next rng)))) 
  where
    as = (_actions state)

--------------------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------------------------

-- mainWithGames (mkStdGen 1234) 10 
-- mainOnlyResults (mkStdGen 1234) 10
-- runConsoleGame
-- runRandomGame
-- runRandomGameAI
-- runRandomGameAgainstRandom
-- runRandomGameAgainstAI

--------------------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------------------------

data MartianChessConfig = MartianChessConfig {
  rampedScores :: Bool
} deriving (Eq, Show)

beginningConfig :: MartianChessConfig -> MartianChessGame
beginningConfig config = MartianChessGame (fromLists [[Queen, Queen, Drone, Empty, Empty, Empty, Empty, Empty], [Queen,Drone,Pawn_,Empty,Empty,Pawn_,Pawn_,Drone], [Drone,Pawn_,Pawn_,Empty,Empty,Pawn_,Drone,Queen], [Empty,Empty,Empty,Empty,Empty,Drone,Queen,Queen]]) (Just DeimosPlayer) (0,0) 250 (rampedScores config)