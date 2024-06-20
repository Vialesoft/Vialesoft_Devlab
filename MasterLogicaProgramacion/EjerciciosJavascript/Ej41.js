function triangulo(filas){
    let triangulo = "";

    for (let i = filas; i > 0; i--) {
        triangulo = repetir(" ", filas-i) + repetir("*", i*2-1) + "\n" + triangulo;
    }

    return triangulo;
}

function repetir(val, cant) {
    return val.repeat(cant);
}

console.log(triangulo(6));