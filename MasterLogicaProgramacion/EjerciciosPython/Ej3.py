def palabraEnFrase(palabra, frase):
    arrayFrase = frase.lower().split(" ")
    repeticiones = len([a for a in arrayFrase if a == palabra.lower()])

    return repeticiones

print(palabraEnFrase("hola", "Hola que hola tal hola como hola te hola va hola hola")); 