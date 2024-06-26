function media(array){
    let suma = array.reduce((acum, actual) => {
        return acum + actual;
    });

    return suma / array.length;
}

console.log(media([1,2,3]));