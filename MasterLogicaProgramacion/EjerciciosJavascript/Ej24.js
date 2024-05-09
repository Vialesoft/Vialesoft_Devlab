function permutacion(lista, numero) {
    let j = 1;

    if (lista.length != numero || numero <= 0) {
        return false;
    }

    for (let i = 0; i < lista.length; i++) {
        if (lista[i] != j) {
            return false;
        }

        j++
    }

    return true;
}

console.log(permutacion([1,2,3,4,5], 5));
console.log(permutacion([1,2,3,3,5], 5));
console.log(permutacion([1,2,4,4,5], 5));
console.log(permutacion([1,2,3,5], 5));