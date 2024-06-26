def todosDe8En8HastaCero(numero):
    resultado = ""

    while numero > 0:
        resultado += "N° " + str(numero) + "\n"

        numero -= 8

    return resultado

print(todosDe8En8HastaCero(100))