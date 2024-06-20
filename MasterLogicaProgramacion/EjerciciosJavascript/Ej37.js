function elementoRepetido(datos) {
    let map = {};
    let max = 1;
    let elemMax = "";

    if(typeof(datos) == "string") {
        datos = datos.split(" ");
    }

    for (elem of datos) {
        if(map[elem]) {
            map[elem]++;

            if (map[elem] > max){
                max = map[elem];
                elemMax = elem;
            }
        } else {
            map[elem] = 1;
        }
    }

    return elemMax;
}

console.log(elementoRepetido([1,2,3,4,4,5,5,6,9]));
console.log(elementoRepetido("ola ke ase programando o ke ase"));