package main;

import "fmt";
import "io/ioutil";
import "os";

func main() {
	fmt.Println("Soy el lector");

	cargarArchivo("fichero.txt");
	escribirTexto("SOY EL NUEVO");
	cargarArchivo("fichero.txt");

}

func showError (e error) {
	if(e != nil) { //nil = no error
		panic(e);
	}
}

func escribirTexto(texto string) {
	texto = "\n" + texto
	fichero, err := os.OpenFile("fichero.txt", os.O_APPEND, 0777);
	showError(err);

	//nuevoTexto := []byte(texto);
	_, err2 := fichero.WriteString(texto);
	fichero.Close();



	showError(err2);
}

func cargarArchivo(fichero string) {
	archivo, errorDeFichero := ioutil.ReadFile(fichero);
	showError(errorDeFichero);

	fmt.Println(string(archivo));
}