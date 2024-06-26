function aficiones(usuarios) {
    let aficiones = [];

    for (u of usuarios) {
        for(a of u.aficiones){
            if(aficiones[a]){
                aficiones[a]++;
            }
            else {
                aficiones[a] = 1;
            }
        }
    }

    return aficiones;
}

const usuarios = [
    { nombre: "Pepe", aficiones: ["Informática", "María", "Robar"]},
    { nombre: "María", aficiones: ["Informática", "Pepe", "Robar"]},
    { nombre: "Fito", aficiones: ["Ladrar", "Comer", "Futbol"]},
    { nombre: "Roberto", aficiones: ["Jugar", "Pepe", "Correr"]}
]

console.log(aficiones(usuarios));