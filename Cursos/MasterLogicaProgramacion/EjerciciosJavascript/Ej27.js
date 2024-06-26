function calcularDias(dias){
    const ano = 365;
    const mes = 30;

    let anos = Math.trunc(dias / ano);
    let resto = dias % ano;

    let meses = Math.trunc(resto / mes)
    dias = resto % mes;

    console.log("Equivale a " + anos + " años, " + meses + " meses, y " + dias + " días");
}

calcularDias(920);