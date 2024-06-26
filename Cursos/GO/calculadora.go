package main

import "fmt"

func main() {
	holaMundo();
}

func holaMundo() { //void
	fmt.Println("hola mundo");
	calculadora();
}

func operacion (num1, num2 float32, op string) float32 {
	var resultado float32 = 0;

	if (op == "+") {
		resultado = num1 + num2;
	}
	if (op == "-") {
		resultado = num1 - num2;
	}
	if (op == "*") {
		resultado = num1 * num2;
	}
	if (op == "/") {
		resultado = num1 / num2;
	}

	return resultado;
}

func calculadora () {
	fmt.Println(operacion(10,15, "+"));
}