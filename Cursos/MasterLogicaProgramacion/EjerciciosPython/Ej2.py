def esPalindromo(palabra):
    palabra_invertida = palabra.lower()[::-1]

    return palabra_invertida == palabra.lower()

print(esPalindromo("Abba"))
print(esPalindromo("ABAB"))