function palabraEnFrase(palabra, frase) {
    let arrayFrase = frase.toLowerCase().split(" ");
    let repeticiones = (arrayFrase.filter(x => x == palabra.toLowerCase())).length;

    return repeticiones;
}

console.log(palabraEnFrase("hola", "Hola que hola tal hola como hola te hola va hola hola"));