package main

import "fmt"

func main() {
	var peliculas[3] string;

	peliculas[0] = "hola";
	peliculas[1] = "qué";
	peliculas[2] = "ase";

	peliculas2 := [3] string {"ola", "ke", "ase"}

	fmt.Println(peliculas);
	fmt.Println(peliculas2);

	var peliculasMulti [3][2] string;
	peliculasMulti[0][0] = "Hola";
	peliculasMulti[0][1] = "ke ase";

	peliculasMulti[1][0] = "Programando en GO";
	peliculasMulti[1][1] = "o ke ase";

	peliculasMulti[2][0] = "Marcianito";
	peliculasMulti[2][1] = "baila cumbia";

	fmt.Println(peliculasMulti);

	var peliculasSlice = []string {
		"Soy",
		"Un",
		"Slice",
		"Que",
		"Es",
		"Lo mismo",
		"Que",
		"Una Lista"}

	peliculasSlice = append(peliculasSlice, "Soy un nuevo elemento");

	fmt.Println(peliculasSlice);

	fmt.Print("Tenemos estas películas: ");
	fmt.Println(len(peliculasSlice));

	fmt.Println(peliculasSlice[0:3]);

}
