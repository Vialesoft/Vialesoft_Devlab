function cuadrados(numero) {
    let listRet = [];

    for(let i = 0; i < numero; i++){
        listRet.push(i**2);
    }

    return listRet;
}

console.log(cuadrados(5));