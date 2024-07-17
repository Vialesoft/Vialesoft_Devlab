--Juego Hijara Samuel, v0.3
--Grupo 6: Federico Becoña, Lorena Ferrando, Ángel Mamberto
--La mejor implementación en Haskell de este juego del infierno

module Samuel where 
    import Data.Char
    import Data.Matrix(Matrix,getCol,getRow,ncols,nrows,toLists,fromLists,submatrix,setElem,getElem)

    data HijaraPlayer = BluePlayer | YellowPlayer deriving (Eq, Show, Enum) --Blue = Pléier1, X, Yellow = Player2, O
    
    --data BluePlayer = BluePlayercito Char
    --data YellowPlayer = YellowPlayercito Char
    
    data HijaraGame = HijaraGame (Matrix String) deriving (Eq)
    instance Show HijaraGame where 
        show(HijaraGame matriz) = show (matriz)
    
    data HijaraAction = HijaraAction(Int, Int) --Cuadante, Posición
    instance Show HijaraAction where 
        show(HijaraAction tupla) = show (tupla)

    beginning :: HijaraGame
    beginning = HijaraGame( fromLists [["1234" | x <- [1..4]] | y <- [1..4]])
    
    hijaraAListaDeListas :: HijaraGame -> [String]
    hijaraAListaDeListas (HijaraGame juego) = (concat(toLists(juego)))

    hijaraALista :: HijaraGame -> String
    hijaraALista (tablero) = concat[l | l <- (hijaraAListaDeListas tablero)]
    
    activePlayer :: HijaraGame -> HijaraPlayer
    activePlayer tablero
        | resul == 64 = error("Juego terminado")
        | odd resul = YellowPlayer
        | otherwise = BluePlayer  
            where resul = cantidadDeFichas tablero

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
    actions jueguito = [(jugadorAct, cuadrantesNoLlenos), (opposite jugadorAct, [])]
        where   lista = hijaraAListaDeListas jueguito
                listita = [lis | lis <- lista, length lista > 0]
                listaPosiciones = (map ((length) . takeWhile (`elem` "XO")) listita)
                listaZipWith = zip ([1..16]) listaPosiciones
                cuadrantesNoLlenos = [HijaraAction(x,(y + 1)) | (x,y) <- listaZipWith, y /= 4] --Obtener las listasPosiciones distintas de 4
                jugadorAct = (activePlayer jueguito)
    
    next :: HijaraGame -> (HijaraPlayer, HijaraAction) -> HijaraGame
    next juego accion@(jugador,movimiento@(HijaraAction(cuadrante, posicion)))
        | jugador /= activePlayer juego = error ("No es su turno") --Tas bien de vivo eh?
        | cantidadDeFichas juego == 64 = error("Juego terminado")
        | accionPosible cuadranteLista movimiento = HijaraGame(fromLists(listaAListaDeListas(cambiar tablero movimiento (fichaPlayer jugador))))
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

    listaAListaDeListas :: [a] -> [[a]]
    listaAListaDeListas [a,b,c,d,e,f,g,h,i,j,k,l,m,n,o,p] = [[a,b,c,d],[e,f,g,h],[i,j,k,l],[m,n,o,p]]

    movimientoValido :: HijaraAction -> Bool
    movimientoValido accion@(HijaraAction (cuadrante, posicion))
        | cuadrante > 16 || cuadrante < 1 || posicion > 4 || posicion < 1 = False
        | otherwise = True

    showGame :: HijaraGame -> String ---------------AAAAAAAAAAAAAAAAAAAAA
    showGame elJuego = concat [' ' : x | x <- laLista]
        where laLista = hijaraAListaDeListas elJuego

    showAction :: HijaraAction -> String
    showAction accion@(HijaraAction(cuadrante, posicion)) = show accion

    


    
    

    --DATOS DE PRUEBA - Para hacer pruebas más fácil :) -
    juegoPosta = beginning --Nuevo juego vacío
    accionDef = HijaraAction(16,1) --Una acción random

    --obtenerCuadrante
    {-

    result :: HijaraGame -> [(HijaraPlayer, Int)]
    
    score :: HijaraGame -> [(HijaraPlayer, Int)]

    readAction :: String -> HijaraAction

    -}