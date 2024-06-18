function repetirTexto(texto, rep) {
    let textoRet = "";
    let i = rep;

    while(i > 0){
        textoRet += texto;
        i--
    }

    return textoRet;
}

console.log(repetirTexto("textoRepetido", 5));