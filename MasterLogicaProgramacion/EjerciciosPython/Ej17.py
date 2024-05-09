def buzz(numero):
    lista = []
    
    for i in range(1, (numero + 1), 1):
        lista.append(i)

    lista = ["BuzzLightYear" if (x % 5 == 0 and x % 3 == 0) else "Lightyear" if x % 5 == 0 else "Buzz" if x % 3 == 0 else x for x in lista]

    return lista

print(buzz(15))