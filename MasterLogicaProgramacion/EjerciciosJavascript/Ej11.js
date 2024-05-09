function censura(texto, busqueda) {
    let textoVacio = vacio(texto);
    let busquedaVacia = vacio(busqueda);
    let censura = "[-CENSURADO-]";

    let error = (textoVacio ? "Texto vacío " : "") + (busquedaVacia ? "Búsqueda vacía" : "");

    if (error != "") {
        return error;
    }

    texto = texto.toUpperCase();
    busqueda = busqueda.toUpperCase();

    let textoCensurado = texto.split(" ")
        .map((x) => {
         if (x == busqueda){
            return censura;
         }
         return x;
        }).join(" ");

    return textoCensurado;
}

function vacio(texto){
    return (texto == null || texto == "");
}

console.log(censura("HOLA QUE TAL HOLA HOLA HOLA", "HOLA"));