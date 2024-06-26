function mayusMinus(palabra){
    let mayus = palabra.split("").filter(x => isUpperCase(x)).length;
    let minus = palabra.split("").filter(x => isLowerCase(x)).length;

    if(minus > mayus){
        return palabra.toLowerCase();
    }

    return palabra.toUpperCase();
}


function isLowerCase(str) {
    return str === str.toLowerCase();
}

function isUpperCase(str) {
    return str === str.toUpperCase();
}

console.log(mayusMinus("HoLaQuEtAl"));
console.log(mayusMinus("holaqueTAL"));
console.log(mayusMinus("HOLAQUEtal"));