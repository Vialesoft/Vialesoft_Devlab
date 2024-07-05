'use strict'

var mongoose = require('mongoose');
var Schema = mongoose.Schema;

var NodeProjectSchema = Schema({
    name: String,
    description: String,
    category: String,
    languages: String,
    year: Number,
    image: String
});

module.exports = mongoose.model('NodeProject', NodeProjectSchema);