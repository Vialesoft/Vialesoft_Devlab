def escalera(escalones):
    retorno = ""
    for i in range(1, (escalones + 1)):
        retorno += generarEscalon(i)

    return retorno

def generarEscalon(cant):
    return ("[-]" * cant) + "\n"

print(escalera(4))
