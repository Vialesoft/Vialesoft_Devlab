function factorial(numero){
    let resultado = numero;

    for(let i = (numero - 1); i > 0; i--){
        resultado *= i;
    }

    return resultado;
}

console.log(factorial(3));