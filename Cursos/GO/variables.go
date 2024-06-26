package main

import "fmt"

type Gorra struct {
	marca string
	color string
	precio float32
	plana bool
}

func main() {
	var suma int = 4 + 5
	var resta int = 10 - 6
	var nombre string = "Pepe";

	fmt.Println("hola " + nombre);
	fmt.Println(suma);
	fmt.Println(resta);

	var gorra_negra = Gorra {
		marca: "Negra",
		color: "Azul",
		precio: 20.36,
		plana: true}

	var gorra_roja = Gorra {"Comunista",color: "Marx",precio: 1919,plana: false}

	fmt.Println(gorra_negra);
	fmt.Println(gorra_roja);
}