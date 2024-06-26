package main;
//package rutas;

import (
	"net/http"
	"github.com/gorilla/mux"
)

type Ruta struct {
	Nombre string
	Metodo string
	Pattern string
	HandlerFunc http.HandlerFunc
}

type Rutas []Ruta;

func NewRouter() *mux.Router {
	router := mux.NewRouter().StrictSlash(true);

	for _, ruta := range rutas {
		router.Name(ruta.Nombre).Methods(ruta.Metodo).Path(ruta.Pattern).Handler(ruta.HandlerFunc);
	}

	return router;
}

var rutas = Rutas{
	Ruta{
		Nombre:"Index",
		Metodo:"GET",
		Pattern:"/",
		HandlerFunc: Index},
	Ruta{
		Nombre:"ListaPeliculas",
		Metodo:"GET",
		Pattern:"/peliculas",
		HandlerFunc: ListaPeliculas},
	Ruta{
		Nombre:"MostrarPelicula",
		Metodo:"GET",
		Pattern:"/peliculas/{id}",
		HandlerFunc: MostrarPelicula},
	Ruta{
		Nombre:"AgregarPelicula",
		Metodo:"POST",
		Pattern:"/peliculas",
		HandlerFunc: AgregarPelicula},
	Ruta{
		Nombre:"ActualizarPelicula",
		Metodo:"PUT",
		Pattern:"/pelicula/{id}",
		HandlerFunc: ActualizarPelicula},
	Ruta{
		Nombre:"EliminarPelicula",
		Metodo:"DELETE",
		Pattern:"/pelicula/{id}",
		HandlerFunc: EliminarPelicula},
	}


		