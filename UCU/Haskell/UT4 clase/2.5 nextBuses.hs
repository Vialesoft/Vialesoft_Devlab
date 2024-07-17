-- ## Ejercicio 2.5: nextBuses

--  + Definir la función `nextBuses` que, dada una lista de buses y una hora inicial
--  + Retorna todas las horas de pasada de esos buses a partir de dicha hora
--   - `let bus1 = Bus {linea="D9", horaInicio=Hora (6,0,0), horaFin=Hora(17,30,0), frecuencia=68}`
--   - `let bus2 = Bus {linea="D10", horaInicio=Hora (12,0,0), horaFin=Hora(19,0,0), frecuencia=27}`
--   - `nextBuses (Hora (16,0,0)) [bus1, bus2] = [("D9",[16:12:0,17:20:00]),("D10",[16:3:0,16:30:0,16:57:0,17:24:0,17:51:0,18:18:0,18:45:0])]`
--  + Asumimos puntualidad inglesa

--  ## Propuesta 2.5: nextBuses

--  + Definir la función `nextBuses` que, dada una lista de buses
--  + Retorna todas las horas de pasada de esos buses

--  `nextBuses :: Hour -> [Bus] -> [(String, [Hour])]
-- nextBuses horaInicio buses = map (\(linea, pasadas) -> (linea, (filter (>= horaInicio) pasadas))) listaPasadas
--     where listaPasadas = busSchedules buses`

--  + ¿Es correcta la implementación?
--  + ¿Puede definirse mejor?

data Hour = Hora (Int, Int, Int)
        | HoraFraccion Double deriving (Eq, Ord)

hour = (1/24)
minute = (hour/60)
second = (minute/60)

data Bus = Bus {
    linea :: String,
    horaInicio :: Hour,
    horaFin :: Hour,
    frecuencia :: Int
}

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

-- Dada una hora de inicio, una hora de fin y una frecuencia en minutos, devolver todas las pasadas en formato hora
busSchedule :: Hour -> Hour -> Int -> [Hour]
busSchedule horaInicio horaFin frecuencia =
    map toHour (takeWhile (<= horaFinDouble) (map (\x -> (x*frecuenciaDouble) + horaInicioDouble) [0..]))
    where   horaInicioDouble = fromHour horaInicio
            horaFinDouble = fromHour horaFin
            frecuenciaDouble = fromHour (Hora (0,frecuencia,0))

busSchedules :: [Bus] -> [(String, [Hour])]
busSchedules buses = lista
    where lista = map (\Bus {linea = l, horaInicio = hI, horaFin = hF, frecuencia = f} -> (l, (busSchedule hI hF f))) buses

nextBuses :: Hour -> [Bus] -> [(String, [Hour])]
nextBuses horaInicio buses = map (\(linea, pasadas) -> (linea, (filter (>= horaInicio) pasadas))) listaPasadas
    where listaPasadas = busSchedules buses