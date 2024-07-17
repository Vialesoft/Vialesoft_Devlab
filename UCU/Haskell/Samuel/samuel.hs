--Juego Hijara Samuel, v0.3
--Grupo 6: Federico Becoña, Lorena Ferrando, Ángel Mamberto
--La mejor implementación en Haskell de este juego del infierno

module Samuel where 
    import Data.Char
    import Data.Matrix(Matrix,getCol,getRow,ncols,nrows,toLists,fromLists,submatrix,setElem,getElem)
    import Data.List
    import Data.Maybe

    data HijaraPlayer = BluePlayer | YellowPlayer deriving (Eq, Show, Enum) --Blue = Pléier1, X, Yellow = Player2, O
    
    --data BluePlayer = BluePlayercito Char
    --data YellowPlayer = YellowPlayercito Char
    
    data HijaraGame = HijaraGame (Matrix String) deriving (Eq)
    instance Show HijaraGame where 
        show(HijaraGame matriz) = show (matriz)
    
    data HijaraAction = HijaraAction(Int, Int) --Cuadrante, Posición
    instance Show HijaraAction where 
        show(HijaraAction tupla) = show (tupla)

    beginning :: HijaraGame
    beginning = HijaraGame( fromLists [["1234" | x <- [1..4]] | y <- [1..4]])
    
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
    actions jueguito =
        | jugadorAct == Nothing = [(YellowPlayer,[]),(BluePlayer,[])]
        | otherwise = [(fromJust(jugadorAct), cuadrantesNoLlenos), (opposite fromJust(jugadorAct), [])]
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
    lista = hijaraAListaDeListas juegoPosta
    mismoCuadrante :: Char -> HijaraGame -> Int
    mismoCuadrante ficha lista = foldl1 (+) (map (sonIguales (ficha)) (hijaraAListaDeListas lista))

    sonIguales ficha lista
        |[ficha,ficha,ficha,ficha] == lista = 20
        | otherwise = 0
    
    --cuadrantesHorizontales LISTAS DE LISTA
    cuadrantesVerticales [a,b,c,d,e,f,g,h,i,j,k,l,m,n,o,p] = [[a,e,i,m],[b,f,j,n],[c,g,k,o],[d,h,l,p]]
    cuadrantesDiagonales [a,b,c,d,e,f,g,h,i,j,k,l,m,n,o,p] =[[a,f,k,p],[m,j,g,d]]
    
    mismaPosicion:: Char -> HijaraGame -> Int
    mismaPosicion  ficha lista = foldl1 (+) (map (samePose (ficha)) (listaAListaDeListas(hijaraAListaDeListas lista))) +foldl1 (+) (map (samePose (ficha)) (cuadrantesVerticales (hijaraAListaDeListas lista))) + foldl1 (+) (map (samePose (ficha)) (cuadrantesDiagonales (hijaraAListaDeListas lista))) 

    samePose ficha lista@([a,b,c,d]) = mismaFicha ficha (a!!0) (b!!0) (c!!0) (d!!0) + mismaFicha ficha (a!!1) (b!!1) (c!!1) (d!!1) + mismaFicha ficha (a!!2) (b!!2) (c!!2) (d!!2) + mismaFicha ficha (a!!3) (b!!3) (c!!3) (d!!3)
    
    puntosEscalera ficha lista = foldl1 (+) (map (escalera (ficha)) (listaAListaDeListas(hijaraAListaDeListas lista))) +foldl1 (+) (map (escalera (ficha)) (cuadrantesVerticales (hijaraAListaDeListas lista))) + foldl1 (+) (map (escalera (ficha)) (cuadrantesDiagonales (hijaraAListaDeListas lista))) 
    escalera ficha lista@([a,b,c,d]) = mismaFicha ficha (a!!0) (b!!1) (c!!2) (d!!3) + mismaFicha ficha (a!!3) (b!!2) (c!!1) (d!!0) 
    
    mismaFicha  ficha a b c d 
        | a == b && b == c && c == d  && d == ficha = 10
        | otherwise = 0

    --DATOS DE PRUEBA - Para hacer pruebas más fácil :) -
    juegoPosta = beginning --Nuevo juego vacío
    accionDef = HijaraAction(16,1) --Una acción random

   

    readAction :: String -> HijaraAction
    readAction orden@[a,b,c,d] = HijaraAction ( (num * 4) + digitToInt b , digitToInt d)
            where valor = "ABCD" 
                  num = fromMaybe 0 (elemIndex a orden)
    readAction _ = error "La accion se define como FilaColumna,posicion sin espacios al final, ejemplo: A2,1"
