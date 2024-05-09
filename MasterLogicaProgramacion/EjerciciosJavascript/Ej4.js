function invertirFraseAMano(frase){
    let fraseInvertida = "";

    for (let i = frase.length - 1; i >= 0; i--) {
        fraseInvertida += frase[i];
    }

    return fraseInvertida;
}

console.log(invertirFraseAMano("HOLE"));