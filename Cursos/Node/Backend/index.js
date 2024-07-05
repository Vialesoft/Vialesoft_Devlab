'use strict'

var mongoose = require('mongoose');
var app = require('./app');
var port = 3700;

mongoose.Promise = global.Promise;
mongoose.connect('mongodb://localhost:27017/Portafolio')
    .then(() => {
        console.log("Hola me conecté a la BD guachím LOL");

        //Creación del servidor
        app.listen(port, () => {
            console.log("Ta re corriendo el servidor bo");
        });
    })
    .catch(err => {
        console.log("Pah me re rompí buasho", err);
    });


