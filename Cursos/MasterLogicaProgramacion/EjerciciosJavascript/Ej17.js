function buzz(numero) {
    let lista = [];
    
    for (let i = 1; i <= numero; i++) {
        lista.push(i);
    }

    lista = lista.map((x) => {
        if (x % 5 == 0 && x % 3 == 0) {
            return "BuzzLightYear";
        }
        else if (x % 5 == 0) {
            return "Lightyear";
        }
        else if (x % 3 == 0) {
            return "Buzz";
        }

        return x;
    });

    return lista;
}

console.log(buzz(15));