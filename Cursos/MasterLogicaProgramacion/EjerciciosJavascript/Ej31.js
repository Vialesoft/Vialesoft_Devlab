function calcularAngulo(angulo) {
    switch(angulo){
        case 0:
        case 360: {
            return "Completo";
        }
        case 90:{
            return "Recto";
        }
        case 180: {
            return "Llano"
        }
        default: {
            if(angulo < 90){
                return "Agudo"
            } else if(angulo < 180){
                return "Obtuso"
            } else {
                return "Cóncavo";
            }
        }
    }
}

console.log(calcularAngulo(0));
console.log(calcularAngulo(360));
console.log(calcularAngulo(90));
console.log(calcularAngulo(180));
console.log(calcularAngulo(87));
console.log(calcularAngulo(162));
console.log(calcularAngulo(270));
console.log(calcularAngulo(289));