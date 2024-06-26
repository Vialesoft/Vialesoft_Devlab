'use strict';

// LocalStorage

if (typeof(Storage) !== undefined) {
    console.log("Habemus Local Storage");
}
else {
    console.log("No habemus Local Storage. Estás usando IE soretito?");
}

//Guardar cosas en LocalStorage
var usuario = {
    nombre: "Pibe",
    apellido: "Feto",
    email: "pfeto@hotmail.com",
    web: "pfeto.com"
}

localStorage.setItem("Usuario", JSON.stringify(usuario));

//Obtener cosas del localStorage
var userStr = (localStorage(getItem("Usuario")));
var userJSLocalStorage = null;

if (userStr != "") {
    userJSLocalStorage = JSON.parse(userStr);
}

console.log(userJSLocalStorage);

