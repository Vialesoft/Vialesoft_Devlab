--  ## Ejercicio 2.1: toHour
--  + Se define el tipo "Hour" para representar horas del día:

--  `data Hour = Hora (Int, Int, Int)
--         | HoraFraccion Double deriving (Eq, Ord)`

--  + Definir la función `toHour` que toma un double representando una fracción de un día
--  + Retorna un tipo Hour conformado por la hora, minutos y segundos que representa esa fracción
--   - `toHour 0.5 = (12, 0, 0)`
--   - `toHour 0.25 = (6, 0, 0)`
--   - `toHour 0.75 = (18, 0, 0)
--   - `toHour 1 = (24, 0, 0)`

--  ## Propuesta 2.1: toHour

--  + Definir la función `toHour` que toma un double representando una fracción de un día
--  + Retorna una tripla conformada por la hora, minutos y segundos que representa esa fracción

--  `toHour :: Double -> Hour
--  toHour fraccion = 
--      let hours = floor (fraccion / hour)
--          minutes = floor (fraccion / minute) - (hours * 60)
--          seconds = floor (fraccion / second) - (hours * 3600) - (minutes * 60)
--      in Hora (hours, minutes, seconds)`

--  + ¿Es correcta la implementación?
--  + ¿Puede definirse mejor?

-------------------------------------------------------------------------------------------------

data Hour = Hora (Int, Int, Int)
        | HoraFraccion Double deriving (Eq)

hour = (1/24)
minute = (hour/60)
second = (minute/60)

toHour :: Double -> Hour
toHour fraccion = 
    let hours = floor (fraccion / hour)
        minutes = floor (fraccion / minute) - (hours * 60)
        seconds = floor (fraccion / second) - (hours * 3600) - (minutes * 60)
    in Hora (hours, minutes, seconds)

