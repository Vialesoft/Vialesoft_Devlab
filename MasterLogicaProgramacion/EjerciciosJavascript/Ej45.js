function suspendidos(array){
    let suspendidos = array.reduce((susp, alumno) => {
        if(alumno[1] <= 6){
            susp++
        }

        return susp;
    }, 0);

    return "Suspendidos: " + suspendidos + " Aprobados: " + (array.length - suspendidos);
}

console.log(suspendidos([
    ["Pepe", 3],
    ["María", 10],
    ["Fito", 6]
]))