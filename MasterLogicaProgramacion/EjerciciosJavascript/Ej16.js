function contarVocales(frase) {
    const vocales = "aeiou";
    frase = frase.toLowerCase().split("");

    let cantidad = frase.filter(x => vocales.includes(x)).length;

    return cantidad;
}

console.log(contarVocales("HOLA KE ASE"));