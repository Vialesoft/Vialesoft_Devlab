-- nextMonth & previousMonth
-- El siguiente tipo enumerado Month representa los días de la semana.

-- Definir las función nextMonth y previousMonth que tome un Month, y retorne el mes siguiente y anterior respectivamente.
-- Variantes:
-- 1. Agregar un argumento que indique cuantos meses hacia adelante o atrás (respectivamente) se quiere ir.
-- Las funciones como están pedidas serían equivalente a tener este argumento extra en 1.
-- 2. Permitir que el argumento anterior sea negativo

data Month = January | February | March
    | April | May | June | July | August
    | September | October | November
    | December deriving (Eq, Show, Enum)

nextMonth :: Month -> Month
nextMonth mes = succ mes

prevMonth :: Month -> Month
prevMonth mes = pred mes

nextMonth' :: Month -> Int -> Month
nextMonth' mes cant
    | cant < 0 = prevMonth' mes (-cant)
    | cant == 0 = mes
    | mes == December = nextMonth' January (cant - 1)
    | otherwise = nextMonth' (succ mes) (cant - 1)

prevMonth' :: Month -> Int -> Month
prevMonth' mes cant
    | cant < 0 = nextMonth' mes (-cant)
    | cant == 0 = mes
    | mes == January = prevMonth' December (cant - 1)
    | otherwise = prevMonth' (pred mes) (cant - 1)

-- Colour
-- Definir un tipo data Colour para representar colores. Un caso debe tener las componentes RGB.
-- Deben haber otros casos para: rojo, azul, verde, blanco y negro.
-- Definir la función toRGB que convierte cualquier Colour al constructor RGB. Por ejemplo:
-- • toRGB Green == (RGB 0 255 0)
-- • toRGB White == (RGB 255 255 255)
-- • toRGB (RGB 1 2 3) == (RGB 1 2 3)
-- Variantes:
-- 1. Definir las funciones red, green, blue que toman un Colour y retornan el valor entero de la componente correspondiente

data Colour = RGB Int Int Int | Rojo | Azul | Verde | Blanco | Negro

toRGB :: Colour -> Colour
toRGB (RGB a b c) = RGB a b c
toRGB Rojo = (RGB 255 0 0)
toRGB Verde = (RGB 0 255 0)
toRGB Azul = (RGB 0 0 255)
toRGB Blanco = (RGB 0 0 0)
toRGB Negro = (RGB 255 255 255)

red :: Colour -> Int
red (RGB a b c) = a

green :: Colour -> Int
green (RGB a b c) = b

blue :: Colour -> Int
blue (RGB a b c) = c

-- AstroDistance
-- Se define un tipo para representar distancias en unidades usadas en astronomía.

-- Definir las funciones de conversión entre unidades. Por ejemplo:
-- • toAstroUnits (LightYears 1.0) = (AstroUnits
-- 63241.0)
-- • toLightYears (Parsecs 1.0) = (LightYears
-- 3.26156)
-- • toParsecs (AstroUnits 1.0) = (Parsecs
-- 4.84815e-6)
-- • toAstroUnits (AstroUnits 2.34) = (AstroUnits
-- 2.34)
-- • toLightYears (LightYears (-1.0)) =
-- (LightYears (-1.0))
-- • toParsecs (Parsecs 1.0) = (Parsecs 1.0)
-- Variantes:
-- 1. Definir las funciones asAstroUnits, asLightYears, asParsecs, que convierten un valor
-- AstroDistance a la unidad correspondiente, pero retornan el valor Double

data AstroDistance = AstroUnits Double | LightYears Double
    | Parsecs Double deriving (Eq, Show)

toAstroUnits :: AstroDistance -> AstroDistance
toAstroUnits (LightYears a) = AstroUnits (a * 63241)
toAstroUnits (AstroUnits a) = AstroUnits a
toAstroUnits (Parsecs a) = AstroUnits (a * 4.84815e-6)

toLightYears :: AstroDistance -> AstroDistance
toLightYears (AstroUnits a) = LightYears (a / 63241)
toLightYears (LightYears a) = LightYears a
toLightYears (Parsecs a) = LightYears (a * 3.26156)

toParsecs :: AstroDistance -> AstroDistance
toParsecs (AstroUnits a) = Parsecs (a / 4.84815e-6)
toParsecs (Parsecs a) = Parsecs a
toParsecs (LightYears a) = Parsecs (a / 3.26156)

asAstroUnits :: AstroDistance -> Double
asAstroUnits a = conv
    where AstroUnits conv = (toAstroUnits a)

asParsecs :: AstroDistance -> Double
asParsecs a = conv
    where Parsecs conv = (toParsecs a)

asLightYears :: AstroDistance -> Double
asLightYears a = conv
    where LightYears conv = (toLightYears a)


-- Naipe
-- El siguiente tipo data Naipe representa las cartas de la baraja española.

-- Escribir las siguientes definiciones:
-- • Función numNaipe para obtener el número de un naipe.
-- • Función suitNaipe para obtener el palo de un naipe: 1 para oros, 2 para copas, 3 para espadas y 4 para bastos.
-- • La lista baraja con todos los naipes de la baraja.

data Naipe = Oros Int | Copas Int
    | Espadas Int | Bastos Int deriving (Show, Eq)

numNaipe :: Naipe -> Int
numNaipe (Oros a) = a
numNaipe (Copas a) = a
numNaipe (Espadas a) = a
numNaipe (Bastos a) = a

suitNaipe :: Naipe -> Int
suitNaipe (Oros a) = 1
suitNaipe (Copas a) = 2
suitNaipe (Espadas a) = 3
suitNaipe (Bastos a) = 4

baraja :: [Naipe]
baraja = [(x y) | x <- [Oros, Copas, Espadas, Bastos], y <- [1..13]]

-- El siguiente tipo BinTree representa árboles binarios.
-- Definir las funciones para los recorridos preorder, inorder, postorder

data BinTree a = Empty
    | Node a (BinTree a) (BinTree a) deriving (Show, Eq)

inorder :: BinTree a -> [a]
inorder (Node n b1 b2) = (inorder b1) ++ n:(inorder b2)

preorder :: BinTree a -> [a]
preorder (Node n b1 b2) = n:(preorder b1) ++ (preorder b2)

postorder :: BinTree a -> [a]
postorder (Node n b1 b2) = (postorder b1) ++ (postorder b2) ++ [n]