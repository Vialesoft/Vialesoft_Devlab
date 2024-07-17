-- ## Ejercicio 2.3: busSchedule
--  + Se define el tipo "Bus" para representar servicios de líneas de buses:

--  `data Bus = Bus {
--     linea :: String,
--     horaInicio :: Hour,
--     horaFin :: Hour,
--     frecuencia :: Int
-- }`

--  + Definir la función `busSchedule` que, dadas una hora de inicio, una hora de fin, y una frecuencia en minutos
--  + Retorna las horas de pasada entre esas dos horas
--   - `busSchedule (Hora (7, 0, 0)) (Hora (9, 0, 0)) 30 = [(7,0,0), (7,30,0), (8,0,0), (8,30,0), (9,0,0)]`
--   - `busSchedule (Hora (10, 0, 0)) (Hora (12, 0, 0)) 25 = [(10,0,0), (10,25,0), (10,50,0), (11,15,0), (11,40,0)]`
--   - `busSchedule (Hora (21, 0, 0)) (Hora (21, 45, 0)) 18 = [(21,0,0), (21,18,0), (21,36,0)]`
--  + Asumimos puntualidad inglesa

--  ## Propuesta 2.3: busSchedule

--  + Definir la función `busSchedule` que, dadas una hora de inicio, una hora de fin, y una frecuencia en minutos
--  + Retorna las horas de pasada entre esas dos horas

--  `busSchedule :: Hour -> Hour -> Int -> [Hour]
-- busSchedule horaInicio horaFin frecuencia =
--     map toHour (takeWhile (<= horaFinDouble) (map (\x -> (x*frecuenciaDouble) + horaInicioDouble) [0..]))
--     where   horaInicioDouble = fromHour horaInicio
--             horaFinDouble = fromHour horaFin
--             frecuenciaDouble = fromHour (Hora (0,frecuencia,0))`

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