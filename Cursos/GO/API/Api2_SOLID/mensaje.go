package main;

type Mensaje struct {
	Status string `json: "status"`
	Mensaje string `json: "mensaje"`
}

//Método dentro del Struct
//El parámetro debe ser un puntero
func (this *Mensaje) setStatus (data string) {
	this.Status = data;
}
func (this *Mensaje) setMensaje (data string) {
	this.Mensaje = data;
}