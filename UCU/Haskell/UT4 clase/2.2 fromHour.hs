-- ## Ejercicio 2.2: fromHour

-- + Definir la función `fromHour` que toma un objeto Hour
-- + Retorna un double que representa la fracción de día de la hora recibida
--  - `fromHour (Hora (12, 0, 0)) = 0.5`
--  - `fromHour (Hora (6, 0, 0)) = 0.25`
--  - `fromHour (Hora (18, 0, 0)) = 0.75`
--  - `fromHour (Hora (24, 0, 0)) = 1.0`

-- ## Propuesta 2.2: fromHour

-- + Definir la función `fromHour` que toma un objeto Hour
-- + Retorna un double que representa la fracción de día de la hora recibida

-- `fromHour :: Hour -> Double
-- fromHour (Hora (h,m,s)) = (hour * fromIntegral h) + (minute * fromIntegral m) + (second * fromIntegral s)
-- fromHour (HoraFraccion fraccion) = fraccion`

-- + ¿Es correcta la implementación?
-- + ¿Puede definirse mejor?

-------------------------------------------------------------------------------------------------

data Hour = Hora (Int, Int, Int)
        | HoraFraccion Double deriving (Eq)

hour = (1/24)
minute = (hour/60)
second = (minute/60)

-- fromHour
fromHour :: Hour -> Double
fromHour (Hora (h,m,s)) = (hour * fromIntegral h) + (minute * fromIntegral m) + (second * fromIntegral s)
fromHour (HoraFraccion fraccion) = fraccion

