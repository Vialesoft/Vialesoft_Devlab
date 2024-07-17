import { Component } from '@angular/core';
import {Configuracion} from './models/configuracion';

@Component({
  selector: 'app-root',
  templateUrl: './app.component.html',
  styleUrls: ['./app.component.css']
})
export class AppComponent {
  public title = 'LA PRIMERA';
  public mostrar_videojuego: boolean = true;
  public config = Configuracion;

  ocultarVideojuego(){
    this.mostrar_videojuego = false;
    this.config = Configuracion;
  }
}
