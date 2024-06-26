function divisores(numero) {
    let lista = [];
    
    for (let i = 1; i <= numero; i++) {
        if (numero % i == 0) {
            lista.push(i);
        }
    }

    return lista;
}

console.log(divisores(15));