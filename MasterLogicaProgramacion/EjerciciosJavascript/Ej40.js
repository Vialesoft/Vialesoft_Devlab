function extremos(array){
    array.sort((a,b) => a - b);

    return [array[0], array[(array.length - 1)]]
}

console.log(extremos([1,2,4,19,4,6]));