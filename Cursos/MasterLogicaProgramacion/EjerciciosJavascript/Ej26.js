function fibonacci (numero) {
    if (numero > 1) {
        let list = fibonacci(numero - 1);
        list.push(list[(numero - 1)] + list[(numero - 2)]);

        return list;
    } else {
        return [0,1]
    }
}

console.log(fibonacci(10));


function fiboNoRecursivo(numero){
    let ret = [0,1];

    for (let i = 2; i <= numero; i++) {
        ret.push(ret[i-1] + ret[i-2]);
    }

    return ret;
}

console.log(fiboNoRecursivo(10));