function substrings(cadena){
    let subs = [];

    for (let i = 0; i < cadena.length; i++) {
        for (let j = i+1; j <= (cadena.length); j++){
            subs.push(cadena.substring(i, j));
        }
    }

    return subs;
}

console.log(substrings("Hola"));