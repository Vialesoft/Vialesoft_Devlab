--Escribe una función myLast :: [a] -> a que, dada una lista de elementos, devuelva el último elemento de la lista

myLast :: [a] -> a
myLast [] = error "Lista vacía"
myLast [x] = x
myLast (x:xs) = myLast xs

myLast2 :: [a] -> a
myLast2 = head . reverse

--Escribe una función myButLast :: [a] -> a que, dada una lista de elementos, devuelva el penúltimo elemento de la lista

myButLast :: [a] -> a
myButLast [] = error "Lista vacía"
myButLast [x] = error "Solo un elemento"
myButLast (x:xs)
    | (length xs == 1) = x
    | otherwise = myButLast xs


myButLast2 :: [a] -> a
myButLast2 [] = error "Lista vacía"
myButLast2 [x] = error "Solo un elemento"
myButLast2 [x, _] = x
myButLast2 (x:xs) = myButLast2 xs

myButLast3 :: [a] -> a
myButLast3 = head . tail . reverse

-- Escribe una función dupli :: [a] -> [a] que duplique los elementos de una lista
-- dupli [1,2,3] = [1,1,2,2,3,3]

dupli :: [a] -> [a]
dupli [] = []
dupli (x:xs) = [x,x] ++ (dupli xs)

dupli2 :: [a] -> [a]
dupli2 [] = []
dupli2 (x:xs) = x:x:dupli2 xs