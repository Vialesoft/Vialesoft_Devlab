// Importar módulos del router de Angular

import { ModuleWithProviders } from "@angular/core";
import { Routes, RouterModule, Router } from "@angular/router";

//Componentes
import { ZapatillasComponent } from "./zapatillas/zapatillas.component";
import { VideojuegoComponent } from "./videojuego/videojuego.component";
import { CursosComponent } from "./cursos/cursos.component";
import { HomeComponent } from './home/home.component';
import { ExternoComponent } from "./externo/externo.component";
import { ContactoComponent } from "./contacto/contacto.component";

//Las rutas
const appRoutes: Routes = [
    {path: "", component: HomeComponent},
    {path: "home", component: HomeComponent},
    {path: "zapatillas", component: ZapatillasComponent},
    {path: "videojuego", component: VideojuegoComponent},
    {path: "externo", component: ExternoComponent},
    {path: "cursos", component: CursosComponent},
    {path: "cursos/:nombre/:followers", component: CursosComponent},
    {path: "contacto", component: ContactoComponent},
    {path: "**", component: HomeComponent} //404
];

//Exportamos

export const appRoutingProviders: any[] = [];
export const routing: ModuleWithProviders<RouterModule> = RouterModule.forRoot(appRoutes);
//https://victorroblesweb.es/2020/07/03/solucion-generic-type-modulewithproviders-requires-1-type-arguments-en-angular-10/
