-- ## Ejercicio 2.4: busSchedules

--  + Definir la función `busSchedules` que, dada una lista de buses
--  + Retorna todas las horas de pasada de esos buses
--   - `let bus1 = Bus {linea="495", horaInicio=Hora (3,0,0), horaFin=Hora(7,0,0), frecuencia=68}`
--   - `let bus2 = Bus {linea="494", horaInicio=Hora (6,0,0), horaFin=Hora(12,0,0), frecuencia=27}`
--   - `busSchedules [bus1, bus2] = [("495",[3:0:0,4:8:0,5:16:0,6:23:59]),("494",[6:0:0,6:27:0,6:54:0,7:21:0,7:48:0,8:15:0,8:42:0,9:9:0,9:36:0,10:3:0,10:30:0,10:57:0,11:24:0,11:51:0])]`
--  + Asumimos puntualidad inglesa

--  ## Propuesta 2.4: busSchedules

--  + Definir la función `busSchedules` que, dada una lista de buses
--  + Retorna todas las horas de pasada de esos buses

--  `busSchedules :: [Bus] -> [(String, [Hour])]
-- busSchedules buses = lista
--     where lista = map (\Bus {linea = l, horaInicio = hI, horaFin = hF, frecuencia = f} -> (l, (busSchedule hI hF f))) buses`

--  + ¿Es correcta la implementación?
--  + ¿Puede definirse mejor?

data Hour = Hora (Int, Int, Int)
        | HoraFraccion Double deriving (Eq)

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


