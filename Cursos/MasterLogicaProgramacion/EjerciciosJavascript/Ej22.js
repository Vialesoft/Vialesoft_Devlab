function mayorMenor(a,b){
    if (a == b) {
        return "No hay mayor";
    }

    if (a > b) {
        return "EL NÚMERO MAYOR ES " + a + "\nEL NÚMERO MENOR ES " + b;
    }

    return "EL NÚMERO MAYOR ES " + b + "\nEL NÚMERO MENOR ES " + a;
}

console.log(mayorMenor(8,9));