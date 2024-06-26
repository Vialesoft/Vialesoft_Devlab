Object = lambda **kwargs: type("Object", (), kwargs)

peliculas = [
    Object(Titulo = "Percy Jackson", Director = "Pedro Dalton", Visto = True),
    Object(Titulo = "El Peluca", Director = "Peluca Peluquín", Visto = False),
    Object(Titulo = "El Hombre que Araña", Director = "Lionel Messi", Visto = True),
    Object(Titulo = "Jarry Póter", Director = "Cristina Fernández", Visto = False)
]

def peliculasVistas():
    vistas = [x.Titulo for x in peliculas if x.Visto]
    noVistas = [x.Titulo for x in peliculas if not x.Visto]

    return "Ya viste " + ", ".join(vistas) + "\nAún no viste " + ", ".join(noVistas)

print(peliculasVistas())