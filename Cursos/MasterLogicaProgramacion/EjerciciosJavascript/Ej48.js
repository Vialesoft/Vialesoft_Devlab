function noRepetidas(string) {
    let ret = new Array();
    let aux = new Array();

    for (c of string) {
        let ind = aux.indexOf(c);

        if (ind > -1) {
            let indRet = ret.indexOf(c);

            if(indRet > -1) {
                ret.splice(indRet, 1);
            }
        } else {
            aux.push(c);
            ret.push(c);
        }
    }

    return ret;
}

console.log(noRepetidas("HOLA KE HASE AMEO"));