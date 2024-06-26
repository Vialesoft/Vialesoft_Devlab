function hacerCuadrado(tamano) {
    if (tamano == 1) return "*";

    let lineaDentro = "*" + " ".repeat(tamano - 2) + "*\n";
    let lineaFuera = "*".repeat(tamano) + "\n";
    let cuadrado = lineaFuera;

    for (let i = 0; i < (tamano - 2); i++) {
        cuadrado += lineaDentro;
    }

    cuadrado += lineaFuera;

    return cuadrado;
}

function hacerCuadradoBucles(tamano) {
    if (tamano == 1) return "*";
    
    let j = 0;
    let lineaDentro = "*";
    let lineaFuera = "*";

    while (j < tamano - 2) {
        lineaDentro += " ";
        lineaFuera += "*";

        j++;
    }

    lineaDentro += "*\n";
    lineaFuera += "*\n";
    
    let cuadrado = lineaFuera;

    for (let i = 0; i < (tamano - 2); i++) {
        cuadrado += lineaDentro;
    }

    cuadrado += lineaFuera;

    return cuadrado;
}

console.log(hacerCuadrado(1));
console.log(hacerCuadradoBucles(1));