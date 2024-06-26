function calculadora(n1, n2){
    const div = n1/n2;
    const prod = n1 * n2;
    const sum = n1 + n2;
    const res = n1 - n2;

    return `
        La suma es: ${sum},
        La resta es: ${res},
        La división es: ${div},
        El producto es: ${prod}`
}

console.log(calculadora(3,4));