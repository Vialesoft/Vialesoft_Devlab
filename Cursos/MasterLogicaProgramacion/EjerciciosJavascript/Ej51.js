function separarPares(array){
    let ret = [];
    let impares = [];

    for (n of array) {
        if(n % 2 == 0) {
            ret.push(n);
        } else {
            impares.push(n);
        }
    }

    return ret.concat(impares);
}

console.log(separarPares([1,2,3,4,5,6,7]));