package main;

// import (
// 	"fmt"
// 	"net/http"
// 	"log"
// 	"github.com/gorilla/mux"
// );

// func main () {
// 	router := mux.NewRouter().StrictSlash(true);
// 	router.HandleFunc("/", Index);
// 	router.HandleFunc("/contacto", Contacto);

// 	fmt.Println("SOY EL SERVIDOR RÍNDANSE ANTE MI");
// 	server := http.ListenAndServe(":8000", router);
// 	log.Fatal(server);

// 	// http.HandleFunc("/", func(response http.ResponseWriter, request *http.Request) {
// 	// 	fmt.Fprintf(response, "HOLA CHUPALA");
// 	// });

// 	// fmt.Println("SOY EL SERVIDOR RÍNDANSE ANTE MI");
// 	//server := http.ListenAndServe(":8000", nil);
// 	// log.Fatal(server);
// }

// func Index (response http.ResponseWriter, request *http.Request) {
// 	fmt.Fprintf(response, "HOLA SOY SKYNET VAN A MORIR TODOS");
// }

// func Contacto (response http.ResponseWriter, request *http.Request) {
// 	fmt.Fprintf(response, "NO QUIERO HABLAR CONTIGO");
// }