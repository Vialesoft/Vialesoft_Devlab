function todosDe8En8HastaCero(numero){
    let resultado = "";
    while(numero > 0) {
        resultado += "N° " + numero.toString() + "\n";

        numero -= 8;
    }

    return resultado;
}

console.log(todosDe8En8HastaCero(100));