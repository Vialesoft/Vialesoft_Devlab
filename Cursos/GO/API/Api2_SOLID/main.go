package main;

import (
	"fmt"
	"net/http"
	"log"
);

func main () {
	router := NewRouter();

	fmt.Println("SOY EL SERVIDOR RÍNDANSE ANTE MI");
	server := http.ListenAndServe(":8000", router);
	log.Fatal(server);
}
