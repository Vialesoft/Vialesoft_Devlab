package main

import "fmt"

func main() {
	fmt.Println(retNombre());
	fmt.Println(gorras(40));

	pantalones("rojo", "negro", "largo", "corto", "feo");
}

func retNombre () (string, string) {
	var nom string = "Pepe";
	var ape string = "Pepez";

	return nom, ape;
}

func pantalones(caracteristicas...string) {
	for _, caracteristica := range caracteristicas {
		fmt.Println(caracteristica);
	}
}

func gorras (pedido float32) (string, float32) {
	precio := func() float32{
		return pedido*7;
	}

	return "El precio del pedido: ", precio();
}