def hacerCuadrado(tamano):
    if tamano == 1:
        return "*"

    lineaDentro = "*" + " " * (tamano - 2) + "*\n"
    lineaFuera = "*" * tamano + "\n"
    cuadrado = lineaFuera

    for i in range(0, tamano - 2):
        cuadrado += lineaDentro

    cuadrado += lineaFuera

    return cuadrado

def hacerCuadradoBucles(tamano):
    if (tamano == 1):
        return "*"
    
    j = 0
    lineaDentro = "*"
    lineaFuera = "*"

    while (j < tamano - 2):
        lineaDentro += " "
        lineaFuera += "*"

        j+= 1

    lineaDentro += "*\n"
    lineaFuera += "*\n"
    
    cuadrado = lineaFuera

    for i in range(tamano - 2):
        cuadrado += lineaDentro

    cuadrado += lineaFuera

    return cuadrado

print(hacerCuadrado(4))
print(hacerCuadradoBucles(4))