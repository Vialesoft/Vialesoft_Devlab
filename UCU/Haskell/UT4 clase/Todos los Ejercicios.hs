--Tipo data Hour
data Hour = Hora (Int, Int, Int)
        | HoraFraccion Double deriving (Eq, Ord)

-- Implementación de Show y Num
instance Show Hour where
    show (Hora (hora, minuto, segundo)) = (show hora) ++":"++(show minuto)++":"++(show segundo)
    show (HoraFraccion h) = show (toHour h)

instance Num Hour where
    (HoraFraccion h) + (HoraFraccion h2) = HoraFraccion (h + h2)
    (Hora h) + (Hora h2) = HoraFraccion (fromHour' h) + HoraFraccion (fromHour' h2)
    (HoraFraccion h) - (HoraFraccion h2) = HoraFraccion (h - h2)
    (Hora (h, m, s)) - (Hora (h2, m2, s2)) = Hora((h-h2), (m-m2), (s-s2))
    --fromInteger x = (HoraFraccion (fromInteger x))

-- toHour
hour = (1/24)
minute = (hour/60)
second = (minute/60)

toHour :: Double -> Hour
toHour fraccion = 
    let hours = floor (fraccion / hour)
        minutes = floor (fraccion / minute) - (hours * 60)
        seconds = floor (fraccion / second) - (hours * 3600) - (minutes * 60)
    in Hora (hours, minutes, seconds)

-- fromHour
fromHour :: Hour -> Double
fromHour (Hora (h,m,s)) = (hour * fromIntegral h) + (minute * fromIntegral m) + (second * fromIntegral s)
fromHour (HoraFraccion fraccion) = fraccion

fromHour' :: (Int, Int, Int) -> Double
fromHour' (h,m,s) = (hour * fromIntegral h) + (minute * fromIntegral m) + (second * fromIntegral s)

data Bus = Bus {
    linea :: String,
    horaInicio :: Hour,
    horaFin :: Hour,
    frecuencia :: Int
}

-- Dada una hora de inicio, una hora de fin y una frecuencia en minutos, devolver todas las pasadas en formato hora
busSchedule :: Hour -> Hour -> Int -> [Hour]
busSchedule horaInicio horaFin frecuencia =
    map toHour (takeWhile (<= horaFinDouble) (map (\x -> (x*frecuenciaDouble) + horaInicioDouble) [0..]))
    where   horaInicioDouble = fromHour horaInicio
            horaFinDouble = fromHour horaFin
            frecuenciaDouble = fromHour (Hora (0,frecuencia,0))

-- Todas las pasadas de todos los buses durante el día
busSchedules :: [Bus] -> [(String, [Hour])]
busSchedules buses = lista
    where lista = map (\Bus {linea = l, horaInicio = hI, horaFin = hF, frecuencia = f} -> (l, (busSchedule hI hF f))) buses

-- A partir de una hora, devolveme las próximas pasadas de todos los buses
nextBuses :: Hour -> [Bus] -> [(String, [Hour])]
nextBuses horaInicio buses = map (\(linea, pasadas) -> (linea, (filter (>= horaInicio) pasadas))) listaPasadas
    where listaPasadas = busSchedules buses


-- busSchedule' :: Hour -> Hour -> Int -> [Hour]
-- busSchedule' horaInicio horaFin frecuencia =
--     let horaI = fromHour horaInicio
--         horaF = fromHour horaFin
--         frec = fromHour (Hora (0,frecuencia,0))
--         cant = ((horaF - horaI) / frec)
--         lista = [(a*b) + horaI | (a,b) <- (zip (repeat frec) [0..cant])]
--     in [toHour x | x <- lista, x <= horaF]

data Casilla = Vacio (Int, Int) | Reina (Int, Int) | Dron (Int, Int) | Peon (Int, Int) deriving (Show)

instance Eq Casilla where
    (==) (Vacio (a,b)) (Vacio (c,d)) = True

