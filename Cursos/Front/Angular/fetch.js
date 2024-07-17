'use strict';

var url1 = "https://jsonplaceholder.typicode.com/users";
var url2 = "https://reqres.in/api/users";

var divUsusarios = document.querySelector("#usuarios");

fetch(url2)
    .then(data => data.json()
        .then(usuarios => {
            listadoUsuarios(usuarios.data);
        }));

function listadoUsuarios(usuarios) {
    usuarios.map((usuario, i) => {
        let nombre = usuario.first_name;
        let apellido = usuario.last_name;
        let nuevoElemento = document.createElement("h2");

        nuevoElemento.innerHTML = nombre + " " + apellido;

        divUsusarios.appendChild(nuevoElemento);
    });
}

function getInfo() {
    var profesor = {
        nombre: "Vístor",
        apellido: "Eucaliptos",
        url: "mygueb.com"
    };

    return new Promise((resolve, reject) => {
        var profesor_string = JSON.stringify(profesor);
        if(typeof profesor_string != "string") {
            return reject ("error");
        }

        return resolve(profesor_string);
    });
}