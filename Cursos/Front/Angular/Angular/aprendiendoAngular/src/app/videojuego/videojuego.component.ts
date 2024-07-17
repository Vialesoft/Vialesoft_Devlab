import { Component, OnInit, DoCheck, OnDestroy } from "@angular/core";

@Component({
    selector: "videojuego",
    templateUrl: './videojuego.component.html'
})

export class VideojuegoComponent implements OnInit, DoCheck, OnDestroy{
    public titulo: string;
    public listado: string;

    constructor() {
        this.titulo = "Componente de videojuegos LALA";
        this.listado = "Soy la lista";

        console.log("SE HA CARGADO EL COMPONENTE VIDEOJUEGO TÍO");
    }

    ngOnInit () {
        console.log("EJECUTAMOS EL ONINIT");
    }

    ngDoCheck() {
        console.log("SOY EL DO CHECK");
    }

    ngOnDestroy(): void {
        console.log("DESTROOOOOYYY MUAHAHAHAHA MUEREEEEE");
    }

    cambiarTitulo() {
        this.titulo = "SOY EL NUEVO TÍTULO";
    }
}