import { Component, OnInit } from '@angular/core';
import { PeticionesService } from '../services/peticiones.service';

@Component({
  selector: 'app-externo',
  templateUrl: './externo.component.html',
  styleUrls: ['./externo.component.css'],
  providers: [PeticionesService]
})

export class ExternoComponent implements OnInit {
  public user: any;
  public userId: number;
  public fecha: any;
  public mensaje: string;
  public nuevo_usuario: any;

  constructor(
    private _peticionesService: PeticionesService
  ) { 
    this.userId = 2;
    this.mensaje = "HOLA MUNDO SOY UN PÁIP";
  }

  ngOnInit(): void {
    this.cargaUsuario();
    this.fecha = new Date();
    this.nuevo_usuario = {"name": "", "job": ""}
  }

  cargaUsuario () {
    this._peticionesService.getUser(this.userId).subscribe(
      result => {
        this.user = result.data;
      },
      error => {
        console.log(<any>error);
      }
    );
  }

  onSubmit(form:any) {
    this._peticionesService.addUser(this.nuevo_usuario).subscribe(
      response => {
        console.log(response);
        alert("HOLA");

        form.reset();
      },
      error => {
        console.log(<any>error);
      }
    );
  }

}
