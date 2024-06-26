function eliminarDuplicados(array){
    //Elimino lo que no sea un número
    array = array.filter(x => !(isNaN(x)));

    //Elimino duplicados
    let setSinDuplicados = new Set(array);

    return Array.from(setSinDuplicados);
}

console.log(eliminarDuplicados([1,2,3,3,"abc","ABC"]));