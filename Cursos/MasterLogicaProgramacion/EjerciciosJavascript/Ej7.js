function imparesEntreDosNumeros(a, b) {
    let resta = maximo(a,b) - minimo(a,b);
    let cant = Math.trunc(resta / 2);

    if(sonImpares(a,b)){
        return cant - 1;
    }

    return cant;
}

function maximo(a, b) {
    if(a > b) return a;

    return b;
}

function minimo(a, b) {
    if(a < b) return a;

    return b;
}

function sonImpares(a, b) {
    if(a % 2 == 0) return false;

    return (b % 2 != 0);
}

console.log(imparesEntreDosNumeros(2,8));