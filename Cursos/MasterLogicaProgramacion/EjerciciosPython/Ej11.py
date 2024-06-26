def censura(texto, busqueda):
    textoVacio = vacio(texto)
    busquedaVacia = vacio(busqueda)
    censura = "[-CENSURADO-]"

    error = ("Texto vacío " if textoVacio else "") + ("Búsqueda vacía" if busquedaVacia else "")

    if (error != ""):
        return error

    texto = texto.lower()
    busqueda = busqueda.lower()

    textoCensuradoList = texto.split(" ")
    textoCensurado = " ".join([censura if a == busqueda else a for a in textoCensuradoList])

    return textoCensurado

def vacio(texto):
    return (texto == None or texto == "")

print(censura("HOLA QUE TAL HOLA HOLA HOLA", "HOLA"))