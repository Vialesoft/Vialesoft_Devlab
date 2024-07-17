import { Component, OnInit } from "@angular/core";
import { Zapatilla } from "../models/zapatilla";
import { ZapatillaService } from "../services/zapatilla.service";

@Component(
{
    selector: 'zapatillas',
    templateUrl: './zapatillas.component.html',
    providers: [ZapatillaService]
})

export class ZapatillasComponent implements OnInit {
    public titulo: string = "Zapatillas";
    public marcasZapatillas: String[];
    public color: string;
    public soyLaMarca: string;
    public zapatillas: Array<Zapatilla>;

    constructor(
        private _zapatillaService: ZapatillaService
    ) {
        this.zapatillas = [];
        this.marcasZapatillas = [];
        this.color = 'yellow';
        this.soyLaMarca = "";
    }

    ngOnInit(): void {
        this.zapatillas = this._zapatillaService.getZapatillas();
        alert(this._zapatillaService.getTextoPrueba());
        this.getMarcas();
    }

    getMarcas () {
        this.zapatillas.forEach((zapatilla, index) => {
            this.marcasZapatillas.push(zapatilla.marca);

            console.log(index);
        });

        console.log(this.marcasZapatillas);
    }

    getMarca(){
        alert(this.soyLaMarca);
    }

    borrarMarca(index: number) {
        //delete this.marcasZapatillas[index];
        this.marcasZapatillas.splice(index, 1);
    }
}