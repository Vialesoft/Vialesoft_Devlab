package main;

import (
	"net/http"
	"encoding/json"
);

func respuestaPelicula(codStatus int, writer http.ResponseWriter, resultados Pelicula) {
	writer.Header().Set("Content-Type", "application/json");
	writer.WriteHeader(codStatus);

	json.NewEncoder(writer).Encode(resultados);
}

func respuestaPeliculas(codStatus int, writer http.ResponseWriter, resultados []Pelicula) {
	writer.Header().Set("Content-Type", "application/json");
	writer.WriteHeader(codStatus);

	json.NewEncoder(writer).Encode(resultados);
}