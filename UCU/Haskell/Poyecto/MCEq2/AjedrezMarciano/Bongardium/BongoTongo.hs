{- Martian Chess ------------------------------------------------------------------------------------------
 
Plantilla de código para el proyecto del curso de 2022 de _Programación Funcional_ para las carreras 
de Ingeniería y Licenciatura en Informática de la FIT (UCU).
Los docentes no garantizan que este código esté libre de errores. De encontrar problemas, por favor
reportarlos a la cátedra.

Leonardo Val, Ángel Mamberto.
-}
module MartianChess where

import Data.Maybe (fromJust, listToMaybe)
import Data.List (elemIndex, sort)
import Data.Char
import System.Random
import Data.Matrix
import Data.Text (splitOn)

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
-- nombre a los data para recordar estado cuando se interrumpe flujo
data MartianChessPlayer = DeimosPlayer | PhobosPlayer deriving (Eq, Show, Enum, Bounded)
data MartianChessGame = MartianChessGame MartianChessPlayer Tablero Puntajes deriving (Eq, Show)
data MartianChessAction = MartianChessAction Coordinate Coordinate deriving (Eq, Show, Read)
data GameResult p = Winner p | Loser p | Draw deriving (Eq, Show)

data Pieza p = Reina p | Dron p | Peon p deriving (Show)

type Coordinate = (Int,Int)
type Puntajes = (Int, Int)

type Tablero = Matrix Int

mit1 = [(1,1),(1,2),(1,3),(1,4),(2,1),(2,2),(2,3),(2,4),(3,1),(3,2),(3,3),(3,4),(4,1),(4,2),(4,3),(4,4)]
mit2= [(1,5),(1,6),(1,7),(1,8),(2,5),(2,6),(2,7),(2,8),(3,5),(3,6),(3,7),(3,8),(4,5),(4,6),(4,7),(4,8)]
tc= [(1,1),(1,2),(1,3),(1,4),(2,1),(2,2),(2,3),(2,4),(3,1),(3,2),(3,3),(3,4),(4,1),(4,2),(4,3),(4,4),(1,5),(1,6),(1,7),(1,8),(2,5),(2,6),(2,7),(2,8),(3,5),(3,6),(3,7),(3,8),(4,5),(4,6),(4,7),(4,8)]

{-IMPORTANTE: LAS 'X' (PRIMER TERMINO DE COORDENADA) SON LAS FILAS, O SEA CRECEN VERTICAL HACIA ABAJO,
Y LAS 'Y' SON LAS COLUMNAS, CRECEN HORIZONTAL HACIA LA DERECHA-}

{-En nuestra función beginning tenemos el estado de la matriz inicial del juego -}
beginning :: MartianChessGame
beginning = MartianChessGame DeimosPlayer tab (0,0)
   where tab = fromLists [[3, 3, 2, 0, 0, 0, 0, 0],
            [3, 2, 1, 0, 0, 1, 1, 2],
            [2, 1, 1, 0, 0, 1, 2, 3],
            [0, 0, 0, 0, 0, 2, 3, 3]]   --matrix 8 4 $ \(i,j) -> 2*i - j

{-activePlayer lo que hace es determinar a que jugador le toca el movimiento siguiente dependiendo
 del estado de juego.En caso que ninguno pueda mover se retorna Nothing. -}

activePlayer :: MartianChessGame -> Maybe MartianChessPlayer
activePlayer g = listToMaybe [p | (p, as) <- actions g, not (null as)]

{-actions lo que hace es tener una lista asociada a cada jugador con los posibles movimientos,
 siempre y cuando sea el turno de dicho jugador, en caso que no lo sea, su lista estará vacía.-}

actions :: MartianChessGame -> [(MartianChessPlayer, [MartianChessAction])]
actions (MartianChessGame j m p) 
   | j == DeimosPlayer = [(j,recorrerD m j), (PhobosPlayer, [])]
   | j == PhobosPlayer = [(DeimosPlayer,[]),(j,recorrerP m j)]
   | otherwise = []

{-Lo que hace es dar una lista con todos los movimientos para este jugador pero sin 
 aplicar filtro.-}

recorrerD :: Tablero -> MartianChessPlayer -> [MartianChessAction]
recorrerD m p = [MartianChessAction x y| x<-mit1, y <-tc , saltarPieza x y p m]

{-Lo que hace es dar una lista con todos los movimientos para este jugador pero sin 
 aplicar filtro-}

recorrerP :: Tablero -> MartianChessPlayer -> [MartianChessAction]
recorrerP m p = [MartianChessAction x y| x<-mit2, y <-tc , saltarPieza x y p m]
--actions (MartianChessGame f) = zip players [if f then [] else [MartianChessAction], []] --TODO

{-validarMovimiento lo que hace es -}
validarMovimiento :: Coordinate -> Coordinate ->  Tablero -> MartianChessPlayer -> Bool
validarMovimiento (x1,y1) (x2,y2) m p
   | (getElem x1 y1 m) == 1 = (movPeon (x1,y1) (x2,y2) m) && limites (x1,y1) (x2,y2) p
   | (getElem x1 y1 m) == 2 = (movDron (x1,y1) (x2,y2) m) && limites (x1,y1) (x2,y2) p
   | (getElem x1 y1 m) == 3 = (movReina (x1,y1) (x2,y2) m) && limites (x1,y1) (x2,y2) p
   | otherwise = False

{-Lo que se hace en movPeon es mover el peon a las coordenadas que se le asigne 
 (siempre que sea válido)-}
movPeon :: Coordinate -> Coordinate ->  Tablero -> Bool
movPeon (x1,y1) (x2,y2) m = abs (x1 - x2)==1 && abs (y1 -y2)==1

{-Lo que se hace en movDron es mover el dron a las coordenadas que se le asigne 
 (siempre que sea válido)-}
movDron :: Coordinate -> Coordinate ->  Tablero -> Bool
movDron (x1,y1) (x2,y2) m
   | x1/=x2 = abs (x1-x2) < 3 && y1==y2
   | otherwise = abs (y1-y2) < 3

{-Lo que se hace en movReina es mover la reina a las coordenadas que se le asigne 
 (siempre que sea válido)-}
movReina :: Coordinate -> Coordinate ->  Tablero -> Bool
movReina (x1, y1) (x2,y2) m
   | abs (x1 - x2)== abs (y1 -y2) = True
   | x1/=x2 = y1==y2
   | otherwise = x1==x2
   
{-Determina si se está saliendo de los parámetros establecidos el movimiento.-}
limites :: Coordinate -> Coordinate -> MartianChessPlayer -> Bool
limites (x1, y1) (x2, y2) p 
   | p== DeimosPlayer = x1> 0 && x1 < 5 && x2>0 && x2 < 5 && y1<5 && y1>0 && y2<9 && y2>0
   | p== PhobosPlayer = x1> 0 && x1 < 5 && x2>0 && x2 < 5 && y1<9 && y1>4 && y2<9 && y2>0


{-saltarPieza va a verificar que no se este pasando por arriba de una pieza en el camino, que no se caiga encima de
una de las piezas del mismo jugador que esta moviendo y llama a validarMovimiento para ver que el resto de aspectos
de la accion a tomar sean adecuados.-}
saltarPieza :: Coordinate -> Coordinate -> MartianChessPlayer -> Tablero -> Bool
saltarPieza (x1, y1) (x2, y2) p m
   | p== DeimosPlayer && (x1, y1) /= (x2, y2) && validarMovimiento (x1, y1) (x2, y2) m p = (trayecto 1 (x1, y1) (x2, y2) p m) && (y2>4||( y2<5 &&(getElem x2 y2 m ==0)))
   | p== PhobosPlayer && (x1, y1) /= (x2, y2) && validarMovimiento (x1, y1) (x2, y2) m p =  (trayecto 1 (x1, y1) (x2, y2) p m) && (y2<5||( y2>4 &&(getElem x2 y2 m ==0)))
   | otherwise = False

{- La funcion trayecto verifica si en el camino entre el lugar original y el destino hay alguna pieza,
en ese caso devuelve false, si el camino esta despejado devuelve true-}
trayecto :: Int -> Coordinate -> Coordinate -> MartianChessPlayer -> Tablero -> Bool
trayecto origen (x1, y1) (x2, y2) p m
   | x1==x2 && y1==y2 = True
   | x1==x2 && y1>y2 = ((getElem x1 y1 m  == 0)||(origen==1)) && trayecto (origen +1) (x1, y1 - 1) (x2, y2) p m
   | x1==x2 && y1<y2 = ((getElem x1 y1 m == 0)||(origen==1)) && trayecto (origen +1) (x1, y1 + 1) (x2, y2) p m
   | x1>x2 && y1==y2 = ((getElem x1 y1 m == 0)||(origen==1)) && trayecto (origen +1) (x1 - 1, y1) (x2, y2) p m
   | x1<x2 && y1==y2 = ((getElem x1 y1 m == 0)||(origen==1)) && trayecto (origen +1) (x1 + 1, y1) (x2, y2) p m
   | x1>x2 && y1>y2 = ((getElem x1 y1 m == 0)||(origen==1)) && trayecto (origen +1) (x1 - 1, y1 - 1) (x2, y2) p m
   | x1>x2 && y1<y2 = ((getElem x1 y1 m == 0)||(origen==1)) && trayecto (origen +1) (x1 -1, y1 + 1) (x2, y2) p m
   | x1<x2 && y1>y2 = ((getElem x1 y1 m == 0)||(origen==1)) && trayecto (origen +1) (x1 + 1, y1 -1) (x2, y2) p m
   | x1<x2 && y1<y2 = ((getElem x1 y1 m == 0)||(origen==1)) && trayecto (origen +1) (x1 +1, y1 +1) (x2 , y2) p m
   | otherwise = False

{-verificar que el mov sea correcto, verificar valor de origen y destino,
cambiar puntajes, cambiar valor de origen y destino, ver si finalizo, llamar accions y esperar input-}
next :: MartianChessGame -> MartianChessPlayer -> MartianChessAction -> MartianChessGame
next (MartianChessGame j t pun) p (MartianChessAction d1 d2)
   | limites d1 d2 p && saltarPieza d1 d2 p t && (activePlayer (MartianChessGame j t pun)) == Just p = cambiarEstado (MartianChessGame j t pun) (MartianChessAction d1 d2)
   | otherwise = MartianChessGame j t pun

--cambiarEstado no solo va a cambiar el tablero sino que va a llamar al cambio de puntajes
-- separo por jugador para sumar al puntaje con el unsafeGet
cambiarEstado :: MartianChessGame -> MartianChessAction -> MartianChessGame
cambiarEstado (MartianChessGame j t (a,b)) (MartianChessAction (x1,y1) (x2,y2))
   | j==DeimosPlayer = MartianChessGame (otherPlayer j) (cambioTab t (x1,y1) (x2,y2)) (a+(unsafeGet x2 y2 t) , b)
   | j==PhobosPlayer = MartianChessGame (otherPlayer j) (cambioTab t (x1,y1) (x2,y2)) (a , b+(unsafeGet x2 y2 t))

-- Se cambia el tablero en las posiciones relevantes al movimiento hecho
cambioTab :: Tablero -> Coordinate -> Coordinate ->Tablero
cambioTab t (x1, y1) (x2, y2) = unsafeSet 0 (x1,y1) (unsafeSet (unsafeGet x1 y1 t) (x2, y2) t) 

{-result da el resultado de juego para cada jugador. Si no está activo devuelve vacío.-}
result :: MartianChessGame -> [GameResult MartianChessPlayer]
result g@(MartianChessGame player table punt )
    | not (activePlayer g == Nothing) = []
    | otherwise = terminado player punt

{-terminado se encarga de ver los puntajes y decidir el ganador.-}
terminado :: MartianChessPlayer -> Puntajes -> [GameResult MartianChessPlayer]
terminado j (a,b)
   | a>b = [Loser PhobosPlayer, Winner DeimosPlayer]
   | a<b = [Loser DeimosPlayer, Winner PhobosPlayer]
   | otherwise = [Loser (otherPlayer j), Winner j]

--Dado un jugador te da el otro
otherPlayer :: MartianChessPlayer -> MartianChessPlayer
otherPlayer p = if p == DeimosPlayer then PhobosPlayer else DeimosPlayer

{-La función showGame nos permite para mostrar el tablero y demás información de la partida -}
showGame :: MartianChessGame -> String
showGame m@(MartianChessGame j t p)= prettyMatrix t

{-showAction convierte una acción a un texto que puede ser impreso
en la consola para mostrarla.-}

showAction :: MartianChessAction -> String
showAction (MartianChessAction cord1 cord2) = "| Mover pieza en " ++show (cord1) ++ " a la coordenada " ++ show(cord2) ++" | "

{- readAction obtiene una acción a partir de un texto que puede
haber sido introducido por el usuario en la consola.-}

readAction :: String -> MartianChessAction
readAction input = repartir a
   where a = filter (/= ' ') input

{-Los metodos repartir van a comunicarse entre si de forma recursiva intentando conseguir las dos coordenadas
para luego crear el MartianChessAction usando el metodo convertir-}
repartir :: String -> MartianChessAction
repartir (x:xs)
   | x=='(' = repartir2 ("",xs)
   | otherwise = repartir xs

repartir2 :: (String,String) -> MartianChessAction
repartir2 (y, (x:xs))
   | x==')' = repartir3 (y,xs)
   | otherwise = repartir2 (y++[x],xs)

repartir3 :: (String,String) -> MartianChessAction
repartir3 (y, (x:xs))
   | x=='(' = repartir4 (y,"",xs)
   | otherwise = repartir3 (y,xs)

repartir4 :: (String,String,String) -> MartianChessAction
repartir4 (y, z, (x:xs))
   | x==')' = MartianChessAction (convertir y) (convertir z)
   | otherwise = repartir4 (y,z++[x],xs)

{-Convierte un string de coordenadas en verdaderas coordenadas-}
convertir :: String -> Coordinate
convertir c = (digitToInt (head c), digitToInt (last c))

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

{-Extras-}
-- El Jugador inteligente va a tomar todos los movimientos que puede hacer y todos en los que puede comer
-- priorizando en su eleccion randomica a aquellos en los que come una pieza
intelligentAgent :: MartianChessPlayer -> MartianChessAgent
intelligentAgent player (MartianChessGame jugador tablero puntajes) = do
    let moves = fromJust (lookup player (actions state))
    if null moves then do
       putStrLn "No moves!"
       return Nothing
    else do
       iAPosibles <- randomRIO (0, (length accionesPosibles) - 1)
       iAComer <- randomRIO (0, (length accionesComer) - 1)
       return  (if length accionesComer > 0 then (Just (accionesComer !! iAComer)) 
               else (Just (accionesPosibles !! iAPosibles)))

   where state = (MartianChessGame jugador tablero puntajes)
         accionesPosibles = let acciones = actions state in head [actionsPosibles | (jug, actionsPosibles) <- acciones, jug == player]
         accionesComer = [(MartianChessAction c1 c2) | (MartianChessAction c1 c2) <- accionesPosibles, (otroCuadro player state c2)]

otroCuadro :: MartianChessPlayer -> MartianChessGame -> Coordinate -> Bool
otroCuadro j (MartianChessGame jug tab punt) (a,b)
   | j == DeimosPlayer = b>4 && (getElem a b tab)/=0
   | otherwise = b<4

{-Con este se prueba el jugador inteligente-}
runIntelligentGame ::  IO [GameResult MartianChessPlayer]
runIntelligentGame  = do
   runGame  (intelligentAgent DeimosPlayer, randomAgent PhobosPlayer)

runIntelligentMatch ::  MartianChessGame -> IO [GameResult MartianChessPlayer]
runIntelligentMatch  g = do
   runMatch (intelligentAgent DeimosPlayer, randomAgent PhobosPlayer) g 

runIntelligentConsoleGame ::  IO [GameResult MartianChessPlayer]
runIntelligentConsoleGame  = do
   runGame  (intelligentAgent DeimosPlayer, consoleAgent PhobosPlayer)


-- Fin
