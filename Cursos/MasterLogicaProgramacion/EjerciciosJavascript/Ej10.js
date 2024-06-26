function escalera(escalones) {
    let retorno = "";
    for (let i = 1; i <= escalones; i++) {
        retorno += generarEscalon(i);
    }

    return retorno;
}

function generarEscalon(cant){
    return "[-]".repeat(cant) + "\n";
}

console.log(escalera(4));
