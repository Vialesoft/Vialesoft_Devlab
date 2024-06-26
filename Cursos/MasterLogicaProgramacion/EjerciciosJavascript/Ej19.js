let peliculas = [
    {
        "Titulo": "Percy Jackson",
        "Director": "Pedro Dalton",
        "Visto": true
    },
    {
        "Titulo": "El Peluca",
        "Director": "Peluca Peluquín",
        "Visto": false
    },
    {
        "Titulo": "El Hombre que Araña",
        "Director": "Lionel Messi",
        "Visto": true
    },
    {
        "Titulo": "Jarry Póter",
        "Director": "Cristina Fernández",
        "Visto": false
    }
];

function peliculasVistas() {
    let vistas = peliculas.filter(x => x.Visto).map(x => x.Titulo);
    let noVistas = peliculas.filter(x => !x.Visto).map(x => x.Titulo);

    return "Ya viste " + vistas.join(", ") + "\nAún no viste " + noVistas.join(", ");
}

console.log(peliculasVistas());