function invertirEntero(num) {
    let numStr = num.toString();

    let numInvertidoStr = numStr.split("").reverse().join("");

    return Number.parseInt(numInvertidoStr);
}

console.log(invertirEntero(867));