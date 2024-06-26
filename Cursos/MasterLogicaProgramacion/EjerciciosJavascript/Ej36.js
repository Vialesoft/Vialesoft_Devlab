function contarVocalesConsonantes(frase){
    let vocales = frase.split("").filter(x => ("AEIOUaeiou".indexOf(x) > -1)).length;
    let consonantes = frase.split("").filter(x => ("BCDFGHJKLMNÑPQRSTVWXYZbcdfghjklmnñpqrstvwxyz".indexOf(x) > -1)).length;

    return `Vocales: ${vocales}, Consonantes: ${consonantes}`;
}

console.log(contarVocalesConsonantes("victorrobles.es"));