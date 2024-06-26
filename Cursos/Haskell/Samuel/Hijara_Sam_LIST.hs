{- Hijara ------------------------------------------------------------------------------------------
 
Plantilla de código para el proyecto del curso de 2019 de _Programación Funcional_ para las carreras 
de Ingeniería y Licenciatura en Informática de la FIT (UCU).
Los docentes no garantizan que este código esté libre de errores. De encontrar problemas, por favor
reportarlos a la cátedra.

Por Leonardo Val.
-}
module Hijara where

import Data.Maybe (fromJust, listToMaybe, fromMaybe)
import Data.List (elemIndex)
import System.Random
import Data.Char
import Data.Matrix(Matrix,getCol,getRow,ncols,nrows,toLists,fromLists,submatrix,setElem,getElem)

{- Es posible que el paquete System.Random no esté disponible si se instaló el core de la Haskell 
Platform en el sistema. Para instalarlo, ejecutar los siguientes comandos:

> cabal update
> cabal install random

La herramienta `cabal` es un manejador de paquetes usado por la plataforma Haskell. Debería estar 
disponible junto con el `ghci`.

-}

{-- Lógica de juego --------------------------------------------------------------------------------
-}

data HijaraPlayer = BluePlayer | YellowPlayer deriving (Eq, Show, Enum, Bounded) --Blue = Pléier1, X, Yellow = Player2, O

data HijaraGame = HijaraGame (Matrix String) deriving (Eq)
instance Show HijaraGame where 
   show(HijaraGame matriz) = let nuevamatriz = (mostrarJuego matriz) in show (nuevamatriz)

mostrarJuego :: Matrix String -> Matrix String
mostrarJuego matriz = fromLists nuevoTablero
   where listas = toLists matriz
         posicionesNumeradas = map (zip [0..3]) listas
         cuadrantesNumerados = zip posicionesNumeradas [1,5..104]
         listita = map(\x -> let a = snd x in (map(\y -> ((a+(fst y)), snd y)) (fst x))) cuadrantesNumerados
         nuevoTablero = map (\lista -> [(show x) ++ " - " ++ y | (x,y) <- lista]) listita

data HijaraAction = HijaraAction(Int, Int) deriving (Eq, Read) --Cuadrante, Posición
instance Show HijaraAction where 
   show(HijaraAction tupla) = show (tupla)

showBoard :: HijaraGame -> String
showBoard elJuego@(HijaraGame matriz) = show (elJuego)

getMatriz elJuego@(HijaraGame matriz) = matriz

beginning :: HijaraGame
beginning = HijaraGame(fromLists [["1234" | x <- [1..4]] | y <- [1..4]])

hijaraAListaDeListas :: HijaraGame -> [String]
hijaraAListaDeListas (HijaraGame juego) = (concat(toLists(juego)))

hijaraALista :: HijaraGame -> String
hijaraALista (tablero) = concat[l | l <- (hijaraAListaDeListas tablero)]

activePlayer :: HijaraGame -> Maybe HijaraPlayer
activePlayer tablero
        | resul == 64 = Nothing -- error("Juego terminado")
        | odd resul = Just YellowPlayer
        | otherwise = Just BluePlayer  
            where resul = cantidadDeFichas tablero

cantidadDeFichas :: HijaraGame -> Int
cantidadDeFichas juego = resul
        where listita = hijaraALista juego
              resul = length [l | l <- (listita), l `elem` "XO"]                

opposite :: HijaraPlayer -> HijaraPlayer                 
opposite YellowPlayer = BluePlayer
opposite BluePlayer = YellowPlayer          

fichaPlayer :: HijaraPlayer -> Char
fichaPlayer YellowPlayer = 'O'
fichaPlayer BluePlayer = 'X'

actions :: HijaraGame -> [(HijaraPlayer, [HijaraAction])]
--actions jueguito = (map ((!!0) . dropWhile (`elem` "XO")) listita) --Alto Puntito
actions jueguito
        | jugadorAct == Nothing = [(YellowPlayer,[]),(BluePlayer,[])]
        | otherwise = [(fromJust(jugadorAct), cuadrantesNoLlenos), (opposite (fromJust jugadorAct), [])]
        where   lista = hijaraAListaDeListas jueguito
                listita = [lis | lis <- lista, length lista > 0]
                listaPosiciones = (map ((length) . takeWhile (`elem` "XO")) listita)
                listaZipWith = zip ([1..16]) listaPosiciones
                cuadrantesNoLlenos = [HijaraAction(x,(y + 1)) | (x,y) <- listaZipWith, y /= 4] --Obtener las listasPosiciones distintas de 4
                jugadorAct = (activePlayer jueguito)
    
next :: HijaraGame -> (HijaraPlayer, HijaraAction) -> HijaraGame
next juego accion@(jugador,movimiento@(HijaraAction(cuadrante, posicion)))
        | cantidadDeFichas juego == 64 = juego -- error("Juego terminado")    
        | jugador /= fromJust(activePlayer juego) = juego -- error ("No es su turno") --Tas bien de vivo eh?
        | accionPosible cuadranteLista movimiento = HijaraGame(fromLists(cuadrantesHorizontales(cambiar tablero movimiento (fichaPlayer jugador))))
            where   tablero = hijaraAListaDeListas juego
                    cuadranteLista = tablero!!(cuadrante-1)
                    posicionEnTablero = cuadranteLista!!(posicion-1)

accionPosible :: [Char] -> HijaraAction -> Bool
accionPosible lista@[a,b,c,d] movimiento@(HijaraAction (cuadrante,posicion))
        | not (movimientoValido movimiento) = error ("Movimiento no válido") --Ahhh querías romperlo ehh? TE-CA-BE 
        | length posicionesLlenas == 4 = error ("Cuadrante lleno")
        | length posicionesLlenas == posicion = error ("Lugar ocupado")
        | length posicionesLlenas /= (posicion - 1) = error ("Posición no válida") --No es la mínima posición dentro del cuadrante
        | otherwise = True
            where posicionesLlenas = filter (`elem` "XO") lista

cambiar :: [String] -> HijaraAction -> Char -> [String]
cambiar tablero movimiento@(HijaraAction (cuadrante, posicion)) ficha =
   cuadrantesPrevios ++ cuadranteModificado ++ cuadrantesLuego
            where   cuads = tablero!!(cuadrante -1)
                    cuadrantesPrevios = take (cuadrante-1) tablero
                    cuadranteModificado = [take (posicion - 1) cuads ++ [ficha] ++ drop (posicion) cuads]
                    cuadrantesLuego = drop (cuadrante) tablero

movimientoValido :: HijaraAction -> Bool
movimientoValido accion@(HijaraAction (cuadrante, posicion))
        | cuadrante > 16 || cuadrante < 1 || posicion > 4 || posicion < 1 = False
        | otherwise = True

showAction :: HijaraAction -> String
showAction accion@(HijaraAction(cuadrante, posicion)) = show accion

result :: HijaraGame -> [(HijaraPlayer, Int)]
result juego 
        | cantidadDeFichas juego /= 64 = []
        | puntosAmarillo == puntosAzul = [(BluePlayer,0),(YellowPlayer,0)]
        | puntosAzul > puntosAmarillo = [(BluePlayer,1),(YellowPlayer,-1)]
        | otherwise = [(BluePlayer,-1),(YellowPlayer,1)]
            where puntosAmarillo = snd((score juego)!!1)
                  puntosAzul =  snd((score juego)!!0)

    
score :: HijaraGame -> [(HijaraPlayer, Int)]
score juego = [(BluePlayer, puntosBlue),(YellowPlayer,puntosAmarillo)]
   where puntosBlue = mismoCuadrante fichaBlue juego +  mismaPosicion fichaBlue juego + puntosEscalera fichaBlue juego
         puntosAmarillo = mismoCuadrante fichaAmarilla juego +  mismaPosicion fichaAmarilla juego + puntosEscalera fichaAmarilla juego
         fichaAmarilla = fichaPlayer YellowPlayer     
         fichaBlue = fichaPlayer BluePlayer   
-- mismoCuadrante juego 
mismoCuadrante :: Char -> HijaraGame -> Int
mismoCuadrante ficha lista = foldl1 (+) (map (sonIguales (ficha)) (hijaraAListaDeListas lista))

sonIguales :: Char -> String -> Int
sonIguales ficha lista
   | [ficha,ficha,ficha,ficha] == lista = 20
   | otherwise = 0
    
--cuadrantesHorizontales LISTAS DE LISTA
cuadrantesVerticales :: [a] -> [[a]]
cuadrantesVerticales [a,b,c,d,e,f,g,h,i,j,k,l,m,n,o,p] = [[a,e,i,m],[b,f,j,n],[c,g,k,o],[d,h,l,p]]

cuadrantesDiagonales :: [a] -> [[a]]
cuadrantesDiagonales [a,b,c,d,e,f,g,h,i,j,k,l,m,n,o,p] =[[a,f,k,p],[m,j,g,d]]

cuadrantesHorizontales :: [a] -> [[a]]
cuadrantesHorizontales [a,b,c,d,e,f,g,h,i,j,k,l,m,n,o,p] = [[a,b,c,d],[e,f,g,h],[i,j,k,l],[m,n,o,p]]
    
mismaPosicion :: Char -> HijaraGame -> Int
mismaPosicion  ficha lista = foldl1 (+) (map (samePose (ficha)) (cuadrantesHorizontales(hijaraAListaDeListas lista))) +foldl1 (+) (map (samePose (ficha)) (cuadrantesVerticales (hijaraAListaDeListas lista))) + foldl1 (+) (map (samePose (ficha)) (cuadrantesDiagonales (hijaraAListaDeListas lista))) 

samePose :: Char -> [String] -> Int
samePose ficha lista@([a,b,c,d]) = mismaFicha ficha (a!!0) (b!!0) (c!!0) (d!!0) 10 + mismaFicha ficha (a!!1) (b!!1) (c!!1) (d!!1) 10 + mismaFicha ficha (a!!2) (b!!2) (c!!2) (d!!2) 10 + mismaFicha ficha (a!!3) (b!!3) (c!!3) (d!!3) 10

puntosEscalera :: Char -> HijaraGame -> Int
puntosEscalera ficha lista = foldl1 (+) (map (escalera (ficha)) (cuadrantesHorizontales(hijaraAListaDeListas lista))) + foldl1 (+) (map (escalera (ficha)) (cuadrantesVerticales (hijaraAListaDeListas lista))) + foldl1 (+) (map (escalera (ficha)) (cuadrantesDiagonales (hijaraAListaDeListas lista))) 

escalera :: Char -> [String] -> Int
escalera ficha lista@([a,b,c,d]) = mismaFicha ficha (a!!0) (b!!1) (c!!2) (d!!3) 15 + mismaFicha ficha (a!!3) (b!!2) (c!!1) (d!!0) 15

mismaFicha :: Char -> Char -> Char -> Char -> Char -> Int -> Int
mismaFicha ficha a b c d valor
   | a == b && b == c && c == d  && d == ficha = valor
   | otherwise = 0

{- readAction :: String -> HijaraAction --A1,4
readAction orden@[a,b,c,d] = HijaraAction ((num * 4) + digitToInt b, digitToInt d)
   where valor = "ABCD" 
         num = getIndex a valor
readAction _ = error "La accion se define como FilaColumna,posicion sin espacios al final, ejemplo: A2,1" -}

readAction :: String -> HijaraAction --1,4, 16,3
readAction orden@[a,b,c] = HijaraAction (digitToInt a, digitToInt c)
readAction orden@[a,b,c,d] = HijaraAction (num, digitToInt d)
   where num = ((digitToInt a) * 10) + digitToInt b
readAction _ = error "La accion se define como Cuadrante,Posicion (sin espacios al final) ejemplos: 2,1; 16,4"

getIndex :: (Eq a) => a -> [a] -> Int
getIndex a (x:xs)
        | xs == [] = 0
        | x==a = 0
        | otherwise = 1 + getIndex a xs

-- activePlayer :: HijaraGame -> Maybe HijaraPlayer
-- activePlayer g = listToMaybe [p | (p, as) <- actions g, not (null as)]

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
      Nothing -> return $ (result g ++ score g)
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

correrRandomConsola :: IO [(HijaraPlayer, Int)]
correrRandomConsola = do
   runMatch (randomAgent BluePlayer, randomAgent YellowPlayer) beginning

{- La función ´correrMixto´ ejecuta toda la partida a partir del estado inicial usando un agentes
de consola y un agente random. Para divertirse compitiendo contra la tecnología poderosa de SAMUEL!!
-}
correrMixto :: IO [(HijaraPlayer, Int)]
correrMixto = do
   runMatch (consoleAgent BluePlayer, randomAgent YellowPlayer) beginning

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
      putStrLn ("Select one move:" ++ concat [" " ++ show m | m <- moves])
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


--runMatch (consoleAgent BluePlayer, consoleAgent YellowPlayer)