def invertirFraseAMano(frase):
    fraseInvertida = ""

    for i in range(len(frase) - 1, -1, -1):
        fraseInvertida += frase[i]

    return fraseInvertida


print(invertirFraseAMano("HOLE"))