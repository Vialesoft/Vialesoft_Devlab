function anagrama(pal1, pal2) {
    let letras = "abcdefghijklmnñopqrstuvwxyz";

    pal1 = ordenar(pal1.toLowerCase().split("").filter(x => (letras.indexOf(x) > -1)).join(""));
    pal2 = ordenar(pal2.toLowerCase().split("").filter(x => (letras.indexOf(x) > -1)).join(""));

    console.log(pal1);
    console.log(pal2);

    return pal1 === pal2;
}

function ordenar(palabra) {
    palabra = palabra.split("");
    for (let i = 0; i < (palabra.length - 1); i++) {
        for (let j = 0; j <= (palabra.length - 1); j++) {
            let letra = palabra[j];
            let letraSiguiente = palabra[j+1];

            if (letraSiguiente < letra) {
                palabra[j] = letraSiguiente;
                palabra[j+1] = letra;
            }
        }
    }

    return palabra.join("");
}

console.log(anagrama("Riesgo", "Sergio"));

console.log("p" > "a");

console.log(ordenar("PUTA"));
