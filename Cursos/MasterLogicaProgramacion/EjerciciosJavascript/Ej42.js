function random(inicio, fin){
    let factor = fin - inicio;

    let ran = Math.floor(Math.random() * factor);

    return inicio + ran;
}

console.log(random(1,100));