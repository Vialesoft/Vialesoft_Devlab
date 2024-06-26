import { Component, OnInit } from '@angular/core';
import { Usuario } from '../models/usuario';

@Component({
  selector: 'app-contacto',
  templateUrl: './contacto.component.html',
  styleUrls: ['./contacto.component.css']
})
export class ContactoComponent implements OnInit {
  public usuario: Usuario;

  constructor() {
    this.usuario = new Usuario("","","","");
  }

  ngOnInit(): void {
  }

  
  onSubmit(form: any) {
    form.reset();
    alert("SOY EL SUBMIT");
    console.log(this.usuario);
  }
}
