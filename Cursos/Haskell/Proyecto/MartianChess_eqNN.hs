{- Tak ------------------------------------------------------------------------------------------
 
Plantilla de código para el proyecto del curso de 2022 de _Programación Funcional_ para las carreras 
de Ingeniería y Licenciatura en Informática de la FIT (UCU).
Los docentes no garantizan que este código esté libre de errores. De encontrar problemas, por favor
reportarlos a la cátedra.

Leonardo Val, Ángel Mamberto.
-}
module MartianChess where

import Data.Maybe (fromJust, listToMaybe)
import Data.List (elemIndex, sort)
import System.Random

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

data MartianChessPlayer = DeimosPlayer | PhobosPlayer deriving (Eq, Show, Enum, Bounded)
data MartianChessGame = MartianChessGame Bool deriving (Eq, Show) --TODO
data MartianChessAction = MartianChessAction deriving (Eq, Show, Read) --TODO
data MartianChessCard = MartianChessCard Int deriving (Eq, Show, Read) --TODO

data GameResult p = Winner p | Loser p | Draw deriving (Eq, Show)

beginning :: MartianChessGame
beginning = MartianChessGame False --TODO

activePlayer :: MartianChessGame -> Maybe MartianChessPlayer
activePlayer g = listToMaybe [p | (p, as) <- actions g, not (null as)]

actions :: MartianChessGame -> [(MartianChessPlayer, [MartianChessAction])]
actions (MartianChessGame f) = zip players [if f then [] else [MartianChessAction], []] --TODO

next :: MartianChessGame -> MartianChessPlayer -> MartianChessAction -> MartianChessGame
next _ _ _ = MartianChessGame True --TODO

result :: MartianChessGame -> [GameResult MartianChessPlayer]
result (MartianChessGame f) = if f then [] else [rf p | (rf, p) <- zip [Winner, Loser] players] --TODO

showGame :: MartianChessGame -> String
showGame g = show g --TODO

showAction :: MartianChessAction -> String
showAction a = show a --TODO
   
readAction :: String -> MartianChessAction
readAction = read --TODO

players :: [MartianChessPlayer]
players = [minBound..maxBound]

{-- Match controller -------------------------------------------------------------------------------

Código de prueba. Incluye una función para correr las partidas y dos agentes: consola y aleatorio.

-}
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

-- Fin
