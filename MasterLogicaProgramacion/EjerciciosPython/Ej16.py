def contarVocales(frase):
    vocales = "aeiou"
    frase = frase.lower()

    cantidad = len([a for a in frase if a in vocales])

    return cantidad

print(contarVocales("HOLA KE ASE"))