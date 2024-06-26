import { Injectable } from "@angular/core";
import { Zapatilla } from "../models/zapatilla";

@Injectable()

export class ZapatillaService {
    public zapatillas: Array<Zapatilla>;

    constructor() {
        this.zapatillas = [
            new Zapatilla("Adibas 1", 300, "Adibas", "blanco", true),
            new Zapatilla("Rebo Robe", 900, "Rebo", "Azul", false),
            new Zapatilla("Nique 3", 250, "Nique", "Naranja", true),
            new Zapatilla("Old Balance aja", 1900, "Old Balance", "Violeta", true)
        ]
    }

    getTextoPrueba() {
        return "HOLA GENTE SOY UN SERVICIO TODO BIEN";
    }

    getZapatillas(): Array<Zapatilla>{
        return this.zapatillas;
    }
}