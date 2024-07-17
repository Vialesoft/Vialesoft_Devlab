{- Hijara ------------------------------------------------------------------------------------------
 
Plantilla de código para el proyecto del curso de 2019 de _Programación Funcional_ para las carreras 
de Ingeniería y Licenciatura en Informática de la FIT (UCU).
Los docentes no garantizan que este código esté libre de errores. De encontrar problemas, por favor
reportarlos a la cátedra.

Por Leonardo Val.
-}
module Hijara where

import Data.Maybe (fromJust, listToMaybe)
import Data.List (elemIndex)
import System.Random

{- Es posible que el paquete System.Random no esté disponible si se instaló el core de la Haskell 
Platform en el sistema. Para instalarlo, ejecutar los siguientes comandos:

> cabal update
> cabal install random

La herramienta `cabal` es un manejador de paquetes usado por la plataforma Haskell. Debería estar 
disponible junto con el `ghci`.

-}

{-- Lógica de juego --------------------------------------------------------------------------------

Funciones de marca sin ninguna implementación útil. Reemplazar por el código apropiado o por imports
a los módulos necesarios.
-}

data HijaraPlayer = BluePlayer | YellowPlayer deriving (Eq, Show, Enum, Bounded)
data HijaraGame = HijaraGame Bool deriving (Eq, Show) --TODO
data HijaraAction = HijaraAction deriving (Eq, Show, Read) --TODO

beginning :: HijaraGame
beginning = HijaraGame False --TODO

actions :: HijaraGame -> [(HijaraPlayer, [HijaraAction])]
actions (HijaraGame f) = zip players [if f then [] else [HijaraAction], []] --TODO

next :: HijaraGame -> (HijaraPlayer, HijaraAction) -> HijaraGame
next _ _ = HijaraGame True --TODO

result :: HijaraGame -> [(HijaraPlayer, Int)]
result (HijaraGame f) = zip players (if f then [] else [1, -1]) --TODO

showBoard :: HijaraGame -> String
showBoard g = show g --TODO

showAction :: HijaraAction -> String
showAction a = show a --TODO
   
readAction :: String -> HijaraAction
readAction = read --TODO

activePlayer :: HijaraGame -> Maybe HijaraPlayer
activePlayer g = listToMaybe [p | (p, as) <- actions g, not (null as)]

players :: [HijaraPlayer]
players = [minBound..maxBound]

{-- Match controller -------------------------------------------------------------------------------

Código de prueba. Incluye una función para correr las partidas y dos agentes: consola y aleatorio.

-}
type HijaraAgent = HijaraGame -> IO (Maybe HijaraAction)

{- La función ´runMatch´ corre la partida completa a partir del estado de juego dado, usando los dos 
agentes dados. Retorna una tupla con los puntajes (score) finales del juego.
-}
runMatch :: (HijaraAgent, HijaraAgent) -> HijaraGame -> IO [(HijaraPlayer, Int)]
runMatch ags@(ag1, ag2) g = do
   putStrLn (showBoard g)
   case (activePlayer g) of
      Nothing -> return $ result g
      Just p -> do
         let ag = [ag1, ag2] !! (fromJust $ elemIndex p players)
         move <- ag g
         runMatch ags (Hijara.next g (p, fromJust move))

{- La función ´runOnConsole´ ejecuta toda la partida a partir del estado inicial usando dos agentes
de consola.
-}
runOnConsole :: IO [(HijaraPlayer, Int)]
runOnConsole = do
   runMatch (consoleAgent BluePlayer, consoleAgent YellowPlayer) beginning

{- El agente de consola ´consoleAgent´ muestra el estado de juego y los movimientos disponibles por
consola, y espera una acción por entrada de texto.
-}
consoleAgent :: HijaraPlayer -> HijaraAgent
consoleAgent player state = do
   let moves = fromJust $ lookup player (actions state)
   if null moves then do
      putStrLn "No moves!"
      getLine
      return Nothing
   else do
      putStrLn ("Select one move:" ++ concat [" "++ show m | m <- moves])
      line <- getLine
      let input = readAction line
      if elem input moves then return (Just input) else do 
         putStrLn "Invalid move!"
         consoleAgent player state

randomAgent :: HijaraPlayer -> HijaraAgent
randomAgent player state = do
    let moves = fromJust $ lookup player (actions state)
    if null moves then do
       putStrLn "No moves!"
       return Nothing
    else do
       i <- randomRIO (0, (length moves) - 1)
       return (Just (moves !! i))
