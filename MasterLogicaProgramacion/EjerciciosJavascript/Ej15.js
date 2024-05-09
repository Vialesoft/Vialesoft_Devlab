function caracterMasUsado(texto, incluirEspacios = false){
    texto = texto.toLowerCase();
    let caracteres = texto.split("").filter((item, index) => texto.indexOf(item) === index);

    if(!incluirEspacios){
        caracteres = caracteres.filter(x => x != " ");
    }

    let caracterMasUsado = "";
    let masRepetido = 0;

    for (c of caracteres) {
        let repeticiones = (texto.split("").filter(x => x == c)).length;

        if (repeticiones > masRepetido) {
            masRepetido = repeticiones;
            caracterMasUsado = c;
        }
    }

    if(caracterMasUsado == " ") caracterMasUsado = "[espacio]";
    
    console.log("Caracter Mas Usado: " + caracterMasUsado + ", " + masRepetido + " veces");
    return caracterMasUsado;
}

console.log(caracterMasUsado("OLA KE ASE PROGRAMANDO O KE ASE", true));