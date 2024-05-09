def caracterMasUsado(texto, incluirEspacios = False):
    texto = texto.lower()
    caracteres = []
    [caracteres.append(x) for x in texto if x not in caracteres]

    if not incluirEspacios:
        caracteres.remove(" ")

    caracterMasUsado = ""
    masRepetido = 0

    for c in caracteres:
        repeticiones = len([a for a in texto if a == c])

        if repeticiones > masRepetido:
            masRepetido = repeticiones
            caracterMasUsado = c

    if caracterMasUsado == " ":
        caracterMasUsado = "[espacio]"
    
    print("Caracter Mas Usado: " + caracterMasUsado + ", " + str(masRepetido) + " veces")
    return caracterMasUsado

print(caracterMasUsado("OLA KE ASE PROGRAMANDO O KE ASE", False))