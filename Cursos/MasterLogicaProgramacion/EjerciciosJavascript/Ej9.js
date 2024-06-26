/*
    Dados dos arrays, devolver un array con los números comunes entre ambos
*/

function devolverComunes(arr1, arr2) {
    return arr1.filter((item, index) => arr1.indexOf(item) === index).filter(x => arr2.includes(x));
}

console.log(devolverComunes([7,8,9,7,5], [4,5,6,7]));