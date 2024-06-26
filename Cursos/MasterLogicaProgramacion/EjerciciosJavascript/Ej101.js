function buscarDosCifras(cadena) {
    for (let i = 9; i >= 1; i--) {
        let index = cadena.indexOf(i.toString());
        if (index != -1 && index != cadena.length - 1) {
            if (cadena[index + 1] == i) {
                return i + "" + i;
            }

            let cadenaAux = cadena.substring(index + 1);
            let i2 = cadena[index + 1];

            while(cadenaAux.indexOf(i.toString()) != -1) {
                let indexAux = cadenaAux.indexOf(i.toString());
                if (cadenaAux[indexAux + 1] == i) {
                    return i + "" + i;
                }

                if (parseInt(cadenaAux[indexAux + 1]) > parseInt(i2)) {
                    i2 = cadenaAux[indexAux + 1];
                }

                cadenaAux = cadenaAux.substring(indexAux + 1);
            }

            return i + "" + i2; 
        }
    }
}

//console.log(buscarDosCifras("11111111111"));

// let a = "1427";
// let b = a.substring(2);

// console.log(b);
