function comprobarPropiedad(objeto, prop) {
    return objeto[prop] !== undefined;
}

const obj = {
    "nombre": "Pepe",
    "raza": "Golden",
    "patas": 5,
    "Dientes": "Todos",
    "Planeta": "Marte",
    "Lee": true,
    "Anecdota": "Una vez trabajó para Elon Musk"
}

console.log(comprobarPropiedad(obj, "patas"));
console.log(comprobarPropiedad(obj, "lele"));