package main;

type Pelicula struct {
	Nombre string `json:"nombre"`
	Ano int `json:"ano"`
	Director string `json:"director"`
}

type Peliculas []Pelicula;