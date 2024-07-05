'use strict'

var Project = require('../models/nodeProjects');

var controller = {
    home: function(req, res) {
        return res.status(200).send({
            message: "Hola mundo, soy la API jóum"
        });
    },

    test: function(req, res) {
        return res.status(200).send({
            message: "Hola mundo soy la API testiada"
        });
    },

    saveProject: function(req, res) {
        var project = new Project();

        var params = req.body;
        project.name = params.name;
        project.description = params.description;
        project.category = params.category;
        project.year = params.year;
        project.languages = params.languages;
        project.image = null;

        var a = project.save()
        .then((projectStored) => {
            if (!projectStored) {
                return res.status(404).send({
                    message: "Project not Found"
                });
            }

            return res.status(200).send({
                project: projectStored,
                message: "Alto save papá"
            });
        })
        .catch((err) => {
            return res.status(500).send({
                message: "Algo se rompió"
            });
        });
    },

    getProject: function(req, res) {
        var projectId = req.params.id;

        Project.findById(projectId, (err, project) => {
            if (err) {
                return res.status(500).send({message: "Error"});
            }

            if (!project) {
                return res.status(404).send({message: "No se encontró el proyecto"});
            }

            return res.status(200).send({
                project
            });
        });
    }
};

module.exports = controller;