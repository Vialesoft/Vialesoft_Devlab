# Dados dos arrays, devolver un array con los números comunes entre ambos

def devolverComunes(arr1, arr2):
    arr1NoDuplicados = []
    [arr1NoDuplicados.append(x) for x in arr1 if x not in arr1NoDuplicados]

    return [a for a in arr1NoDuplicados if a in arr2]

print(devolverComunes([7,8,9,7,5], [4,5,6,7]))