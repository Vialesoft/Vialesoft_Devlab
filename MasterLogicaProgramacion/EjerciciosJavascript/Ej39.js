function email(texto){
    let emailValido = /^\w+@\w+\.\w/.test(texto);

    return emailValido;
}

console.log(email("algo@algo.com.uy"));
console.log(email("algo@algo.com"));
console.log(email("nada"));
console.log(email("algo@pepe.edu.com.uy"));