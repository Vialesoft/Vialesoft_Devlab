function dividirArray(array, tamArray) {
    if (array.length <= tamArray){
        return [array];
    }

    let arrayRetorno = [];
    let subArr = [];
    for (let i = 0; i < array.length; i++) {
        subArr.push(array[i]);

        if (subArr.length == tamArray) {
            arrayRetorno.push(subArr);
            subArr = [];
        }
    }

    if (subArr.length < tamArray && subArr.length != 0) {
        arrayRetorno.push(subArr);
    }

    return arrayRetorno;
}

console.log(dividirArray([7,8,9,10,11], 2));