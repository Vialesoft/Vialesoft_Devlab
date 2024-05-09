def imparesEntreDosNumeros(a, b):
    resta = maximo(a,b) - minimo(a,b)
    cant = (resta // 2)

    if (sonImpares(a,b)):
        return cant - 1

    return cant

def maximo(a, b):
    if(a > b):
        return a

    return b

def minimo(a, b):
    if(a < b):
        return a

    return b

def sonImpares(a, b):
    if(a % 2 == 0):
        return False

    return (b % 2 != 0)

print(imparesEntreDosNumeros(3,8))