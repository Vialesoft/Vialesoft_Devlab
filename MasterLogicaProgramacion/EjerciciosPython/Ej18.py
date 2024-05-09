def divisores(numero):
    lista = []
    
    for i in range (1, (numero + 1), 1):
        if (numero % i == 0):
            lista.append(i)

    return lista

print(divisores(15))