function fraseEnMayuscula(frase){
    frase = frase.split(" ").map(x => x[0].toUpperCase() + x.slice(1)).join(" ");

    return frase;
}

console.log(fraseEnMayuscula("puto el que lee"));