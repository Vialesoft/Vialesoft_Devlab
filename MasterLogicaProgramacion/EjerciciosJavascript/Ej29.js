function capicua(numero){
    let invertido = invertirEntero(numero);

    return invertido == numero;
}

//Función Ejercicio 8
function invertirEntero(num) {
    let numStr = num.toString();

    let numInvertidoStr = numStr.split("").reverse().join("");

    return Number.parseInt(numInvertidoStr);
}

console.log(capicua(2042));