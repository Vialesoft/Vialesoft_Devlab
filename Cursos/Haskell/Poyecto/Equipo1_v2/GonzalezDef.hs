{- Martian Chess -----------------------------------------------------------------------------------
Plantilla de código para el proyecto del curso de 2022 de _Programación Funcional_ para las carreras 
de Ingeniería y Licenciatura en Informática de la FIT (UCU).
Los docentes no garantizan que este código esté libre de errores. De encontrar problemas, por favor
reportarlos a la cátedra.

Integrantes: 
   Carlos Nicolas Gonzalez
   Bruno Arnuti
   Jose Curti.

Leonardo Val, Ángel Mamberto.
-}

module MartianChess where

import Data.Maybe (fromJust, listToMaybe)
import Data.List (elemIndex, sort)
import Data.Matrix
import Data.Data
import Data.Char
import System.Random

--import System.Random

{- Es posible que el paquete `System.Random` no esté disponible si se instaló el core de la Haskell 
Platform en el sistema. Para instalarlo, ejecutar los siguientes comandos:

> cabal update
> cabal install --lib random

La herramienta `cabal` es un manejador de paquetes usado por la plataforma Haskell. Debería estar 
disponible junto con el `ghci`.

-}

{-- Lógica de juego --------------------------------------------------------------------------------

Funciones de marca sin ninguna implementación útil. Reemplazar por el código apropiado o por imports
a los módulos necesarios.
-}

data MartianChessPlayer = DeimosPlayer | PhobosPlayer deriving (Eq, Enum,Show, Bounded)

data MartianChessGame = MartianChessGame {
   tablero      :: Tablero, -- El tablero actual del juego
   puntosDeimos :: Int, -- El contador de puntos de Deimos
   puntosPhobos :: Int, -- El contador de puntos de Phobos
   actPlayer :: MartianChessPlayer 
}



data MartianChessAction  = Mover (Int, Int) (Int, Int)  deriving (Eq) --TODO


data GameResult p = Winner p | Loser p | Draw deriving (Eq, Show)


data Casilla = Vacio  | Reina  | Dron | Peon  deriving (Eq,Show)



type Tablero = Matrix Casilla


beginning :: MartianChessGame
beginning = MartianChessGame (fromLists lista) 0 0 DeimosPlayer
   where lista =  [ [Vacio, Vacio , Vacio , Dron ,  Vacio,  Dron ,  Reina ,  Reina ]
                  , [Dron,  Peon ,  Peon ,  Vacio ,  Vacio , Peon ,  Dron ,   Reina ]
                  , [Reina, Dron ,  Peon ,  Vacio ,  Vacio , Peon ,  Peon ,   Dron ]
                  , [Reina, Reina , Dron ,  Vacio ,  Vacio , Vacio , Vacio ,  Vacio ]]

      -- where lista =  [ [Vacio, Vacio , Vacio ,  Vacio ,  Vacio , Vacio,  Vacio ,  Vacio ]
      --             , [Vacio, Vacio , Reina ,  Vacio ,  Reina , Peon , Peon ,  Vacio ]
      --             , [Vacio, Vacio , Vacio ,  Vacio ,  Vacio , Reina , Peon ,  Vacio ]
      --             , [Vacio, Vacio , Vacio ,  Vacio ,  Peon , Peon , Peon ,  Vacio ]]


                  

result :: MartianChessGame -> [GameResult MartianChessPlayer]
result (MartianChessGame tablero puntosDeimos puntosPhobos actPlayer)
   | isFinished tablero = if puntosDeimos > puntosPhobos then [ Winner DeimosPlayer,  Loser PhobosPlayer] else [ Winner PhobosPlayer,  Loser DeimosPlayer]
   | otherwise = []

isFinished :: Tablero -> Bool
isFinished tablero = all (== Vacio) sub1 || all (==Vacio) sub2
   where sub1 = submatrix 1 4 1 4 tablero
         sub2 = submatrix 1 4 5 8 tablero   

showGame :: MartianChessGame -> String
showGame m@(MartianChessGame tablero puntosDeimos puntosPhobos actPlayer)
   = "\n    1     2     3     4     5     6     7     8 \n" ++
   "\n" ++ "Phobos: " ++ (show puntosPhobos) ++ " - " ++ "Deimos: "
      ++ (show puntosDeimos) ++ prettyMatrix tablero

actions :: MartianChessGame -> [(MartianChessPlayer, [MartianChessAction])]
actions game@(MartianChessGame tablero puntosDeimos puntosPhobos actPlayer) 
   | actPlayer==DeimosPlayer = [(actPlayer,recorrerTableroPlayer sub1 game)]
   | otherwise = [(actPlayer,recorrerTableroPlayer sub2 game)]
      where sub1= [(f, c, getElem f c tablero) | f <- [1..4], c <- [1..4]]
            sub2= [(f, c, getElem f c tablero) | f <- [1..4], c <- [5..8]]
      --  where sub1 = submatrix 0 0 3 3 tablero
      --        sub2 = submatrix 3 3 7 7 tablero 


recorrerTableroPlayer:: [(Int,Int,Casilla)]  -> MartianChessGame-> [MartianChessAction]
recorrerTableroPlayer t game@(MartianChessGame tablero puntosDeimos puntosPhobos actPlayer) = [m | (f, c, x) <- t, x /= Vacio, m <- _movimientos (f, c, x) game]

---recorrerTableroPlayer list@(:xs) game@(MartianChessGame tablero puntosDeimos puntosPhobos actPlayer) = if x/= Vacio then _movimientos x game : recorrerTableroPlayer xs game else [] : recorrerTableroPlayer xs game



_esPuntoValido :: (Int,Int) -> Bool
_esPuntoValido (x, y) = x >= 1 && x <= 4 && y >= 1 && y <= 8 -- Verifica que las coordenadas recibidas estén dentro del tablero


-- _Muevo :: MartianChessGame -> (Int,Int,Casilla) ->(Int,Int) -> MartianChessAction
-- _Muevo game@(MartianChessGame tablero puntosDeimos puntosPhobos actPlayer) casillaOrigen@(xo,yo,pieza) posicionDestino@(x,y)
--    | pieza ==Vacio = Mover (xo,yo) posicionDestino
--    | pieza && actPlayer==DeimosPlayer && x>3 = Mover (xo,yo) posicionDestino
--    | pieza && actPlayer==PhobosPlayer && x<4 = Mover (xo,yo) posicionDestino


_PosibleMover :: MartianChessGame  -> (Int,Int) -> Bool
_PosibleMover game@(MartianChessGame tablero puntosDeimos puntosPhobos actPlayer) posicionDestino@(x,y)
   | getElem x y tablero  ==Vacio = True
   | actPlayer==DeimosPlayer && y>4 = True
   | actPlayer==PhobosPlayer && y<5 = True
   | otherwise = False

---- Esta funcion sirve para validar que cuando va a venir el movimiento en diagonal, no muestre el segundo movimiento luego de encontrar una ficha enemiga.
_PosibleMoverDiagonal :: MartianChessGame  -> (Int,Int) -> (Int,Int) -> Bool
_PosibleMoverDiagonal game@(MartianChessGame tablero puntosDeimos puntosPhobos actPlayer) posicionOrigen@(xo,yo) posicionDestino@(x,y)
   | actPlayer==DeimosPlayer && y>4 && x>xo && y>yo && (getElem (x-1) (y-1) tablero)/=Vacio && xo/=(x-1) && yo/=(y-1) =False
   | actPlayer==DeimosPlayer && y>4 && x>xo && y<yo && (getElem (x-1) (y+1) tablero)/=Vacio && xo/=(x-1) && yo/=(y+1) =False
   | actPlayer==DeimosPlayer && y>4 && x<xo && y>yo && (getElem (x+1) (y-1) tablero)/=Vacio && xo/=(x+1) && yo/=(y-1) =False
   | actPlayer==DeimosPlayer && y>4 && x<xo && y<yo && (getElem (x+1) (y+1) tablero)/=Vacio && xo/=(x+1) && yo/=(y+1) =False
   | actPlayer==PhobosPlayer && y<5 && x>xo && y>yo && (getElem (x-1) (y-1) tablero)/=Vacio && xo/=(x-1) && yo/=(y-1) =False
   | actPlayer==PhobosPlayer && y<5 && x>xo && y<yo && (getElem (x-1) (y+1) tablero)/=Vacio && xo/=(x-1) && yo/=(y+1) =False
   | actPlayer==PhobosPlayer && y<5 && x<xo && y>yo && (getElem (x+1) (y-1) tablero)/=Vacio && xo/=(x+1) && yo/=(y-1) =False
   | actPlayer==PhobosPlayer && y<5 && x<xo && y<yo && (getElem (x+1) (y+1) tablero)/=Vacio && xo/=(x+1) && yo/=(y+1) =False
   | otherwise = True
---- Esta funcion sirve para validar que cuando va a venir el movimiento en Horizontal o Vertical, no muestre el segundo movimiento luego de encontrar una ficha enemiga.
_PosibleMoverHV :: MartianChessGame  -> (Int,Int) -> (Int,Int) -> Bool
_PosibleMoverHV game@(MartianChessGame tablero puntosDeimos puntosPhobos actPlayer) posicionOrigen@(xo,yo) posicionDestino@(x,y)
   | actPlayer==DeimosPlayer && y>4 && x==xo && y>yo && (getElem x (y-1) tablero)/=Vacio &&  yo/=(y-1) =False
   | actPlayer==DeimosPlayer && y>4 && x==xo && y<yo && (getElem x (y+1) tablero)/=Vacio &&  yo/=(y+1) =False
   | actPlayer==DeimosPlayer && y>4 && y==yo && x>xo && (getElem (x-1) y tablero)/=Vacio && xo/=x-1  =False
   | actPlayer==DeimosPlayer && y>4 && y==yo && x<xo && (getElem (x+1) y tablero)/=Vacio && xo/=x+1  =False
   | actPlayer==PhobosPlayer && y<5 && x==xo && y>yo && (getElem x (y-1) tablero)/=Vacio &&  yo/=(y-1) =False
   | actPlayer==PhobosPlayer && y<5 && x==xo && y<yo && (getElem x (y+1) tablero)/=Vacio &&  yo/=(y+1) =False
   | actPlayer==PhobosPlayer && y<5 && y==yo && x>xo && (getElem (x-1) y tablero)/=Vacio && xo/=x-1  =False
   | actPlayer==PhobosPlayer && y<5 && y==yo && x<xo && (getElem (x+1) y tablero)/=Vacio && xo/=x+1  =False
   | otherwise = True





   --data MartianChessAction a = Moverse Casilla (Int, Int)  a | Comer Casilla (Int, Int) a deriving (Eq, Show, Read) --TODO

_movimientos :: (Int,Int,Casilla) -> MartianChessGame -> [MartianChessAction]
_movimientos coordenada@(x,y,Peon) game@(MartianChessGame tablero puntosDeimos puntosPhobos actPlayer) 
   =  [Mover (x, y) dest | dest <- [(x-1,y-1), (x-1,y+1),(x+1,y-1),(x+1,y+1)], _esPuntoValido dest && _PosibleMover game dest]

_movimientos coordenada@(x,y,Dron) game@(MartianChessGame tablero puntosDeimos puntosPhobos actPlayer) 
   =  [Mover (x, y) dest | dest <- [(x + x1, y + y1)| x1 <- [-2..2], y1 <- [-2..2], (x1/=0 && y1==0) || (y1/=0 && x1==0)   ],_esPuntoValido dest && _PosibleMover game dest  && _PosibleMoverHV game (x ,y) dest]

_movimientos coordenada@(x,y,Reina) game@(MartianChessGame tablero puntosDeimos puntosPhobos actPlayer) 
    = [Mover (x, y) dest | dest <-  (foldl (++) [] [takeWhile (\punto -> _esPuntoValido punto && _PosibleMover game punto && _PosibleMoverHV game (x, y) punto && _PosibleMoverDiagonal game (x, y) punto)  [(x + (s1 * d), y + (s2 * d)) | d <- [1..]] | s1 <- [-1..1], s2 <- [-1..1], s1 /= 0 || s2 /= 0] )]

      --[Mover (x, y) dest | dest <-  (foldl (++) [] [takeWhile (\punto -> _esPuntoValido punto && _PosibleMover game punto)  [(x + (s1 * d), y + (s2 * d)) | d <- [1..]] | s1 <- [-1,1], s2 <- [-1,1] ] )] ++
      --- La primera parte es movimiento en diagonal, tuve que usar un takeWhile porque va obteniendo los valores siempre y cuando cumpla la funcion
--- cuando no cumple, va por otra diagonal... esto devuelve una lista de puntos, lo cual no me sirve, por eso hacgo un foldl para obtener cada punto y ir pasando .


activePlayer :: MartianChessGame -> Maybe MartianChessPlayer
activePlayer g = listToMaybe [p | (p, as) <- actions g, not (null as)]





next :: MartianChessGame -> MartianChessPlayer -> MartianChessAction -> MartianChessGame
next game@(MartianChessGame tablero puntosDeimos puntosPhobos actPlayer) DeimosPlayer action@(Mover (xO, yO) (xD, yD))  --- Cambio de Jugador activo y le sumo los puntos--- El tablero le dejo vacio la casilla de origen
   =    MartianChessGame (setElem Vacio (xO, yO) tableroResultadoParcial) (puntosDeimos+puntos) puntosPhobos PhobosPlayer
   where puntos= valorfichas (getElem xO yO tablero) (getElem xD yD tablero) --- Obtengo los puntos Correspondiente a la ficha de destino.
         tableroResultadoParcial= setElem (getElem xO yO tablero) (xD, yD) tablero --- Primero el lugar de destino ya le seteo la nueva ficha

next game@(MartianChessGame tablero puntosDeimos puntosPhobos actPlayer) PhobosPlayer action@(Mover (xO, yO) (xD, yD))  --- Cambio de Jugador activo y le sumo los puntos--- El tablero le dejo vacio la casilla de origen
   =    MartianChessGame (setElem Vacio (xO, yO) tableroResultadoParcial) puntosDeimos (puntosPhobos+puntos) DeimosPlayer
   where puntos= valorfichas (getElem xO yO tablero) (getElem xD yD tablero) --- Obtengo los puntos Correspondiente a la ficha de destino.
         tableroResultadoParcial= setElem (getElem xO yO tablero) (xD, yD) tablero --- Primero el lugar de destino ya le seteo la nueva ficha


   ---como descompongo un MartianChessAction  Mover (Int, Int) (Int, Int)

valorfichas :: Casilla -> Casilla -> Int
valorfichas casillaOrigen casillaDestino
   | casillaOrigen==Reina || casillaDestino == Peon = 1
   | casillaOrigen==Reina || casillaDestino == Dron = 2
   | casillaOrigen==Reina || casillaDestino == Reina = 3
   | casillaOrigen==Dron || casillaDestino == Peon = 2
   | casillaOrigen==Dron || casillaDestino == Dron = 3
   | casillaOrigen==Dron || casillaDestino == Reina = 4
   | casillaOrigen==Peon || casillaDestino == Peon = 3
   | casillaOrigen==Peon || casillaDestino == Dron = 4
   | casillaOrigen==Peon || casillaDestino == Reina = 5
   | otherwise = 0

  --- data MartianChessPlayer = DeimosPlayer | PhobosPlayer deriving (Eq, Show, Enum, Bounded)
instance (Show MartianChessAction) where
   show (Mover (x,y) (xd,yd)) = "\n Origen: " ++ show (x,y) ++ "-- Destino: " ++ show (xd,yd)

-- instance (Show MartianChessPlayer) where
--    show x = "Jugador: " ++ show x  

   --data MartianChessAction  = Mover (Int, Int) (Int, Int)  deriving (Eq) 
showAction :: MartianChessAction -> String
showAction x = show x 


readAction :: String -> MartianChessAction
readAction xs
    = let l = [ digitToInt x | x <- xs, x `elem` ['1'..'8'] ] 
        in if length l == 4
            then Mover (l !! 0, l !! 1) (l !! 2, l !! 3)
            else Mover (0, 0) (0, 0) 

players :: [MartianChessPlayer]
players = [minBound..maxBound]

-- {-- Match controller -------------------------------------------------------------------------------

-- Código de prueba. Incluye una función para correr las partidas y dos agentes: consola y aleatorio.

-- -}
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
         runMatch ags (MartianChess.next g p (fromJust move))

runGame :: (MartianChessAgent, MartianChessAgent) -> IO [GameResult MartianChessPlayer]
runGame ags = do
  runMatch ags beginning

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
      putStrLn ("Select one move:" ++ concat [" "++ showAction m | m <- moves])
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

-- -- Fin
