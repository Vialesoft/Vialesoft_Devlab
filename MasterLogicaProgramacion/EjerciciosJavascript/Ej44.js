function dosPalabras(array, palabras = 2) {
    // let ret = array.filter((x) => {
    //     return /^\w+ +\w/.test(x);
    // });

    let ret = array.filter((x) => {
        return x.split(" ").length == palabras;
    });

    return ret;
}

console.log(dosPalabras(["hola", "hola que tal", "hola hoola", "opa opa", "vaso vaso", "pepe manuela"], 3));