module MartianChess where

import Data.Maybe (fromJust, listToMaybe)
import Data.List
import GameData
import Util

{----------------------------------- Lógica de juego -----------------------------------}

-- Estado inicial del juego
beginning :: MartianChessConfig -> MartianChessGame
beginning config = Playing PhobosPlayer initialBoard initialScore config

-- Devuelve el jugador que tiene el turno
-- Nothing si ningun jugador puede moverse, ej si se termino el juego
activePlayer :: MartianChessGame -> Maybe MartianChessPlayer
activePlayer (Playing aPlyr _ _ _) = Just aPlyr
activePlayer (Finished _) = Nothing

-- Lista con una tupla por jugador
-- La tupla del jugador activo debe contener todas las acciones posibles que pueda realizar
-- Para los jugadores inactivos, debe estar vacia
actions :: MartianChessGame -> [(MartianChessPlayer, [MartianChessAction])]
actions (Finished _) = map (\p -> (p, [])) players
actions state = (aPlyr, possibleActions state) : map (\plyr -> (plyr,[])) (filter (/=aPlyr) players)
    where (Playing aPlyr brd _ _) = state

-- Ejecuta una accion del jugador activo, y devuelve el proximo estado
-- Si el jugador no esta activo, el juego esta terminado, o la accion no es posible, se devuelve error
next :: MartianChessGame -> MartianChessPlayer -> MartianChessAction -> MartianChessGame
next (Finished rst) _ _ = error ("Game finished with result: " ++ showResult rst)
next (Playing aPlyr _ _ _) p _ | aPlyr /= p = error ("Player " ++ show p ++ " not active!")
next state aPlyr action | all (/=action) (concat[pActions | (p, pActions) <- actions state, p == aPlyr]) = error ("Not valid action: " ++ showAction action)
next (Playing aPlyr brd scr config) _ act
    | maxRounds -1 <= 0 = Finished (if isDraw then Draw else Winner (if playerScore ns PhobosPlayer > playerScore ns DeimosPlayer then PhobosPlayer else DeimosPlayer))
    | hasWinner nb ns nc == Nothing = Playing np nb ns nc 
    | otherwise = Finished (Winner winner)
    where 
        np = nextPlayer aPlyr
        nb = nextBoard act brd
        ns = nextScore (Playing aPlyr brd scr nc) act
        nc = MartianChessConfig {points = points, maxRounds = maxRounds-1}
        Just winner = hasWinner nb ns nc
        isDraw = playerScore ns PhobosPlayer == playerScore ns DeimosPlayer
        MartianChessConfig {points=points, maxRounds = maxRounds} = config

-- Retorna el resultado del juego terminado para cada jugador
-- Si no esta terminado se retorna lista vacia
result :: MartianChessGame -> [GameResult MartianChessPlayer]
result (Finished (Winner plyr)) = [Winner plyr, Loser (nextPlayer plyr)]
result _ = []

-- Convierte el estado del juego en algo imprimible por consola
-- Muestra el tablero y otros detalles
showGame :: MartianChessGame -> String
showGame (Finished rst) = joinLn [line 22, "Game Finished -> " ++ showResult rst]
showGame m@(Playing aPlyr brd scr (MartianChessConfig {maxRounds=mr})) = joinLn [line 22,"","Movimientos restantes: "++show mr, formatPlayer PhobosPlayer, show brd, formatPlayer DeimosPlayer, "", (show (remaining m))]
    where formatPlayer = \plyr -> concat [take 5 (repeat ' '), show plyr, " (", show (playerScore scr plyr), ")", (if plyr == aPlyr then " <>" else "")]

movesByScore :: MartianChessGame -> [(MartianChessAction, Int)]
movesByScore (Playing ap brd scr config) = filter (\(ac, points) -> points > 0) [_movesByScore action config | action <- possibleActions (Playing ap brd scr config)]

_movesByScore :: MartianChessAction -> MartianChessConfig -> (MartianChessAction, Int)
_movesByScore (Eat piece xyi enemy xyf) config = ((Eat piece xyi enemy xyf), eatValue config piece enemy)
_movesByScore action _ = (action, 0)

eatValue :: MartianChessConfig -> Piece -> Piece -> Int
eatValue config piece enemy = pieceValue config enemy + (if rs then pieceValue config (maxBound :: Piece) - pieceValue config piece else 0)
    where (MartianChessConfig {rampedScores =rs}) = config

-- Convierte una accion en un texto que la identifique
showAction :: MartianChessAction -> String
showAction (Move piece xyi xyf) = "\n" ++ intercalate " " [show piece, show xyi, "->", show xyf]
showAction (Eat piece xyi enemy xyf) = "\n" ++ intercalate " " [show piece,  show xyi,  "->", show enemy, show xyf]

-- Crea una accion a partir un texto introducido por el usuario
readAction :: String -> MartianChessAction
readAction str 
    | length (words str) < 4 || (words str !! 2) /= "->" = error "Invalid action"
    | length parts == 4 = Move (readPiece piece) (read xyi :: (Int, Int)) (read (params!!0) :: (Int, Int))
    | length parts == 5 = Eat (readPiece piece) (read xyi :: (Int, Int)) (readPiece (params!!0)) (read (params!!1) :: (Int, Int))
    | otherwise = error "Invalid action"
    where 
        parts@(piece:xyi:arrow:params) = words str


{----------------------------------- Custom methods -----------------------------------}


-- Devuelve la lista de acciones permitidas del estado de juego actual (acciones del jugador activo)
possibleActions :: MartianChessGame -> [MartianChessAction]
possibleActions state = [moveToAction board piece xyi xyf | (piece, xyi) <- boardCoordinates state, xyf <- pieceMoves state piece xyi]
    where (Playing aPlayer board score _) = state

-- Crea una MartianChessAction a partir de la informacion necesaria
moveToAction :: Board -> Piece -> (Int, Int) -> (Int,Int) -> MartianChessAction
moveToAction board piece xyi xyf | pieceIn xyf board == Empty = Move piece xyi xyf
moveToAction board piece xyi xyf = Eat piece xyi (pieceIn xyf board) xyf

-- Calcula los posibles movimientos de una pieza en cierta posicion
pieceMoves :: MartianChessGame -> Piece -> (Int, Int) -> [(Int, Int)]
pieceMoves state Pawn xy  = diagonalMoves state xy 1
pieceMoves state Drone xy = (horizontalMoves state xy 2) ++ (verticalMoves state xy 2)
pieceMoves state Queen xy = (diagonalMoves state xy (-1)) ++ (horizontalMoves state xy (-1)) ++ (verticalMoves state xy (-1))
pieceMoves _ Empty _ = []

-- Calcula los posibles movimientos horizontales
horizontalMoves :: MartianChessGame -> (Int, Int) -> Int -> [(Int, Int)]
horizontalMoves state xy i = lefts ++ rights
    where
        lefts = findNexts (\(xi, yi) -> (xi-1, yi))
        rights = findNexts (\(xi, yi) -> (xi+1, yi))
        findNexts = move state xy i

-- Calcula los posibles movimientos verticales
verticalMoves :: MartianChessGame -> (Int, Int) -> Int -> [(Int, Int)]
verticalMoves state xy i = ups ++ downs
    where
        ups = findNexts (\(xi, yi) -> (xi, yi+1))
        downs = findNexts (\(xi, yi) -> (xi, yi-1))
        findNexts = move state xy i

-- Calcula los posibles movimientos diagonales
diagonalMoves :: MartianChessGame -> (Int, Int) -> Int -> [(Int, Int)]
diagonalMoves state xy i = upLefts ++ upRights ++ downLefts ++ downRights
    where
        upRights = findNexts (\(xi, yi) -> (xi+1, yi+1))
        upLefts = findNexts (\(xi, yi) -> (xi-1, yi+1))
        downLefts = findNexts (\(xi, yi) -> (xi-1, yi-1))
        downRights = findNexts (\(xi, yi) -> (xi+1, yi-1))
        findNexts = move state xy i

-- Calcula genericamente los posibles movimientos a partir de:
--   - Posicion de origen: (x,y)
--   - Cantidad maxima de saltos: i
--   - Estado actual del juego + Jugador activo
--   - Funcion generadora de la proxima posicion: getNext
move :: MartianChessGame -> (Int, Int) -> Int -> ((Int, Int) -> (Int,Int)) -> [(Int, Int)] 
move _ _ 0 _ = []
move (Playing aPlyr brd scr config) (x,y) i getNext
    | isOutOfBorder = []
    | isEmpty = nextP : move (Playing aPlyr brd scr config) nextP (i-1) getNext
    | isEnemyPiece = [nextP]
    | otherwise = []
    where
        nextP@(xf, yf) = getNext (x,y)
        isOutOfBorder =  xf<0 || xf>7 || yf<0 || yf>3
        isEmpty = pieceIn nextP brd == Empty
        isEnemyPiece = playerIn nextP /= aPlyr

-- Devuelve el proximo tablero luego de ejecutar una accion
nextBoard :: MartianChessAction -> Board -> Board
nextBoard (Move piece xyi xyf) (Board board) = Board (insertMatrix (insertMatrix board piece xyf) Empty xyi)
nextBoard (Eat piece xyi _ xyf) (Board board) = Board (insertMatrix (insertMatrix board piece xyf) Empty xyi)

-- Devuelve el proximo jugador
nextPlayer :: MartianChessPlayer -> MartianChessPlayer
nextPlayer DeimosPlayer = PhobosPlayer
nextPlayer PhobosPlayer = DeimosPlayer

-- Devuelve el proximo puntaje luego de ejecutar una accion
nextScore :: MartianChessGame -> MartianChessAction -> Score
nextScore (Playing aPlyr _ (Score score) config) (Eat piece xyi enemy xyf) = Score (map (\(player, points) -> if (player == aPlyr) then (player, points + pieceValue config enemy) else (player, points)) score)
nextScore (Playing aPlyr _ score config) (Move pice xyi xyf) = score

-- Si el juego termino, devuelve el ganador. Sino Nothing
hasWinner :: Board -> Score  -> MartianChessConfig -> Maybe MartianChessPlayer
hasWinner board score (MartianChessConfig {maxRounds = mr})
    | mr <= 0 = if phobosScore > deimosScore then Just PhobosPlayer else Just DeimosPlayer
    | (phobosVoided || deimosVoided) && phobosScore > deimosScore = Just PhobosPlayer
    | (phobosVoided || deimosVoided) && phobosScore < deimosScore = Just DeimosPlayer
    | phobosVoided = Just PhobosPlayer
    | deimosVoided = Just DeimosPlayer
    | otherwise = Nothing
    where
        phobosVoided = all (\row -> all (==Empty) row) (playerZone board PhobosPlayer)
        deimosVoided = all (\row -> all (==Empty) row) (playerZone board DeimosPlayer)
        phobosScore = playerScore score PhobosPlayer
        deimosScore = playerScore score DeimosPlayer
        

--Devuelve las zonas del jugador 
playerZone :: Board -> MartianChessPlayer -> [[Piece]]
playerZone (Board board) PhobosPlayer = take 4 board 
playerZone (Board board) DeimosPlayer = drop 4 board 

-- Devuelve el puntaje actual de un jugador
playerScore :: Score -> MartianChessPlayer -> Int
playerScore (Score scr) player = head [points | (plyr, points) <- scr, plyr == player]

-- Obtiene el jugador dueño de la zona de (x,y)
playerIn :: (Int, Int) -> MartianChessPlayer
playerIn (x,y) | x > 3 = DeimosPlayer
playerIn _ = PhobosPlayer

-- Obtiene la pieza en la posicion (x,y) del tablero
pieceIn :: (Int, Int) -> Board -> Piece
pieceIn (x,y) (Board brd) = (brd !! x) !! y

-- Devuelve el valor de una pieza
pieceValue :: MartianChessConfig -> Piece -> Int
pieceValue _ Empty = 0
pieceValue (MartianChessConfig {points = p}) piece = p !! index
    where Just index = findIndex (==piece) (tail [minBound..maxBound] :: [Piece])

--Devuelve las coordenadas del Board
boardCoordinates :: MartianChessGame -> [(Piece, (Int, Int))]
boardCoordinates (Playing PhobosPlayer board score _) = [(pieceIn (x,y) board, (x,y)) | x <- [0..3], y <-[0..3]]
boardCoordinates (Playing DeimosPlayer board score _) = [(pieceIn (x,y) board, (x,y)) | x <- [4..7], y <-[0..3]]