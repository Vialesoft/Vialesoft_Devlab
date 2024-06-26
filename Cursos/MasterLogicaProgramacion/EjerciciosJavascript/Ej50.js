function bucles(numero) {
    let numBucle = ["0","6","8","9"];
    numero = numero.toString().split("");
    let cantBucles = 0;

    soloBucles = numero.filter((x) => {
        return numBucle.indexOf(x) > -1;
    });

    for(n of soloBucles){
        switch(n){
            case "8":{
                cantBucles += 2;
                break;
            }
            default: {
                cantBucles++;
                break;
            }
        }
    }

    return cantBucles;
}

console.log(bucles(28661));