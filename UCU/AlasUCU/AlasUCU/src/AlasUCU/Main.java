/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package AlasUCU;

import Clases.*;
import UCUGrafos.*;
import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.util.LinkedList;

/**
 *
 * @author Lithium582
 */
public class Main {

    /**
     * @param args the command line arguments
     */
    public static void main(String[] args) {
        try {
            AlaUCU alita = AlaUCU.getInstancia();

            String direccionArchivoAeropuertosSiEsLargoAProposito = "src/Archivos/Aeropuertos.csv";
            String direccionArchivoAeroLineasNoTanLargo = "src/Archivos/Aerolineas.csv";
            String direccionArchivoVuelosCorto = "src/Archivos/vuelos_produccion.csv";

            //alita.cargarGrafo(direccionArchivoAeropuertosSiEsLargoAProposito, direccionArchivoAeroLineasNoTanLargo, direccionArchivoVuelosCorto);
            Integer op = -1;
            Boolean b = false;

            while (op != 0) {
                try {
                    BufferedReader br = new BufferedReader(new InputStreamReader(System.in));
                    if (b) {
                        System.out.println(" ----------------------------------------------- ");
                        System.out.println(" ------------ ENTER para continuar ------------- ");
                        System.out.println(" ----------------------------------------------- ");
                        br.readLine();
                    } else {
                        b = !b;
                    }

                    System.out.println(" ----------------------------------------------- ");
                    System.out.println(" ----------- Bienvenido a Alas UCU ------------- ");
                    System.out.println(" ---------- La mejor forma de volar ------------ ");
                    System.out.println(" ------ Ingrese una opción para continuar: ----- ");
                    System.out.println(" ----------------------------------------------- ");
                    System.out.println(" ------------- Cargar Archivos CSV ------------- ");
                    System.out.println("1 --> Cargar Datos");
                    System.out.println(" ----------------- Aerolíneas ------------------ ");
                    System.out.println("2 --> Nueva Aerolínea");
                    System.out.println("3 --> Buscar Aerolínea");
                    System.out.println(" -------------------- Vuelos ------------------- ");
                    System.out.println("4 --> Nuevo Vuelo");
                    System.out.println("5 --> Buscar Vuelos");
                    System.out.println(" ----------------- Aeropuertos ----------------- ");
                    System.out.println("6 --> Nuevo Aeropuerto");
                    System.out.println("7 --> Buscar Aeropuerto");
                    System.out.println("8 --> Eliminar Aeropuerto");
                    System.out.println(" ------------------ Búsquedas ------------------ ");
                    System.out.println("9 --> Buscar");
                    System.out.println("0 - SALIR");
                    System.out.print("Ingrese una opción \n");

                    try {
                        op = Integer.parseInt(br.readLine());
                    } catch (Exception ex) {
                        op = -1;
                        System.out.println("Opción incorrecta");
                    }

                    switch (op) {
                        case 1: {
                            try {
                                System.out.println("Ingrese el archivo que quiere cargar");
                                System.out.println("1 - Archivo de aerolíneas");
                                System.out.println("2 - Archivo de aeropuertos");
                                System.out.println("3 - Archivo de vuelos");
                                System.out.println("4 - Todos los archivos");
                                Integer subOP = Integer.parseInt(br.readLine());

                                String direccionAerolineas = "";
                                String direccionAeropuertos = "";
                                String direccionVuelos = "";

                                switch (subOP) {
                                    case 1: {
                                        System.out.println("Cargando archivo de aerolíneas...");

                                        System.out.println("Ingrese la dirección del archivo");
                                        System.out.println("\t0 para cargar el archivo por defecto 'src/Archivos/Aerolineas.csv'");
                                        direccionAerolineas = br.readLine().trim();
                                        if (direccionAerolineas.equals("0")) {
                                            direccionAerolineas = "src/Archivos/Aerolineas.csv";
                                        }
                                        
                                        if(alita.cargarGrafo("", direccionAerolineas, "")){
                                            System.out.println("Archivo cargado satisfactoriamente");
                                        } else{
                                            System.out.println("No se ha podido cargar el archivo");
                                        }

                                        break;
                                    }
                                    case 2: {
                                        System.out.println("Cargando archivo de aeropuertos...");

                                        System.out.println("Ingrese la dirección del archivo");
                                        System.out.println("\t0 para cargar el archivo por defecto 'src/Archivos/Aeropuertos.csv'");
                                        direccionAeropuertos = br.readLine().trim();
                                        if (direccionAeropuertos.equals("0")) {
                                            direccionAeropuertos = "src/Archivos/Aeropuertos.csv";
                                        }
                                        
                                        if(alita.cargarGrafo(direccionAeropuertos, "", "")){
                                            System.out.println("Archivo cargado satisfactoriamente");
                                        } else{
                                            System.out.println("No se ha podido cargar el archivo");
                                        }

                                        break;
                                    }
                                    case 3: {
                                        System.out.println("Cargando archivo de vuelos...");

                                        System.out.println("Ingrese la dirección del archivo");
                                        System.out.println("\t0 para cargar el archivo por defecto 'src/Archivos/vuelos_produccion.csv'");
                                        direccionVuelos = br.readLine().trim();
                                        if (direccionVuelos.equals("0")) {
                                            direccionVuelos = "src/Archivos/vuelos_produccion.csv";
                                        }
                                        
                                        if(alita.cargarGrafo("", "", direccionVuelos)){
                                            System.out.println("Archivo cargado satisfactoriamente");
                                        } else{
                                            System.out.println("No se ha podido cargar el archivo");
                                        }

                                        break;
                                    }
                                    case 4: {
                                        System.out.println("Ingrese la dirección del archivo de aeropuertos");
                                        System.out.println("\t0 para cargar los archivos por defecto");

                                        direccionAeropuertos = br.readLine().trim();

                                        if (direccionAeropuertos.equals("0")) {
                                            direccionAeropuertos = "src/Archivos/Aeropuertos.csv";
                                            direccionAerolineas = "src/Archivos/Aerolineas.csv";
                                            direccionVuelos = "src/Archivos/vuelos_produccion.csv";
                                            
                                            if(alita.cargarGrafo(direccionAeropuertos, direccionAerolineas, direccionVuelos)){
                                                System.out.println("Archivo cargado satisfactoriamente");
                                            } else{
                                                System.out.println("No se ha podido cargar el archivo");
                                            }
                                            
                                        } else {
                                            System.out.println("Ingrese la dirección del archivo de aerolíneas");
                                            direccionAerolineas = br.readLine().trim();

                                            System.out.println("Ingrese la dirección del archivo de vuelos");
                                            direccionVuelos = br.readLine().trim();

                                            if(alita.cargarGrafo(direccionAeropuertos, direccionAerolineas, direccionVuelos)){
                                                System.out.println("Archivo cargado satisfactoriamente");
                                            } else{
                                                System.out.println("No se ha podido cargar el archivo");
                                            }
                                        }

                                        break;
                                    }
                                }
                            } catch (Exception ex) {
                                System.out.println("Opción incorrecta");
                            }
                            break;
                        }
                        case 2: {
                            System.out.println("Ingresar nueva aerolínea");
                            System.out.println("Ingrese el código de la aerolínea (2 caracteres de largo)");
                            String aeroCode = br.readLine();

                            if (aeroCode.length() == 2) {
                                Aerolinea objAeroBuscado = alita.buscarAerolinea(aeroCode);
                                if (objAeroBuscado != null) {
                                    System.out.println("La aerolínea " + objAeroBuscado.getNombre() + " ingresada ya existe");
                                } else {
                                    System.out.println("Ingrese el nombre de la aerolínea");
                                    String aeroNombre = br.readLine();

                                    Aerolinea objAerolinea = new Aerolinea(aeroCode, aeroNombre);

                                    boolean res = alita.nuevaAerolinea(objAerolinea);

                                    if (res) {
                                        System.out.println("Aerolínea insertada con éxito!");
                                    } else {
                                        System.out.println("Atención. Ha habido un problema con la inserción\nIntente más tarde");
                                    }
                                }
                            } else {
                                System.out.println("Código inválido. Debe tener dos caracteres");
                            }

                            break;
                        }
                        case 3: {
                            System.out.println("Buscar una aerolínea");
                            System.out.println("Ingrese el código de la aerolínea\n\t 0 - Listar todas");
                            String aeroCode = br.readLine();

                            if (aeroCode.equals("0")) {
                                LinkedList<Aerolinea> todasLasAerolineas = alita.getAerolineas();

                                if (todasLasAerolineas.isEmpty()) {
                                    System.out.println("No hay ninguna aerolínea registrada");
                                } else {
                                    for (Aerolinea objAeroFor : todasLasAerolineas) {
                                        System.out.println(objAeroFor.getID() + " --> " + objAeroFor.getNombre());
                                    }
                                }
                            } else {
                                Aerolinea objAeroBuscado = alita.buscarAerolinea(aeroCode);
                                if (objAeroBuscado == null) {
                                    System.out.println("La aerolínea \"" + aeroCode + "\" no existe");
                                } else {
                                    System.out.println(objAeroBuscado.toString());
                                }
                            }

                            break;
                        }
                        case 4: {
                            System.out.println("Ingresar un nuevo vuelo");
                            System.out.println("Ingrese el aeropuerto de origen");
                            String origen = br.readLine();

                            Aeropuerto aeroPuertoOrigen = alita.buscarAeropuerto(origen);

                            if (aeroPuertoOrigen == null) {
                                System.out.println("El aeropuerto no está registrado");
                            } else {
                                System.out.println("Ingrese el aeropuerto de destino");
                                String destino = br.readLine();

                                Aeropuerto aeroPuertoDestino = alita.buscarAeropuerto(destino);

                                if (aeroPuertoDestino == null) {
                                    System.out.println("El aeropuerto no está registrado");
                                } else {
                                    System.out.println("Origen: " + aeroPuertoOrigen.imprimir());
                                    System.out.println("Destino: " + aeroPuertoDestino.imprimir());

                                    LinkedList<Aerolinea> aerolineas = alita.getAerolineas();
                                    Aerolinea objAerolineaElegida = null;
                                    int costoViaje = -1;

                                    int opcionAerolinea = -1;

                                    while (opcionAerolinea != 0) {
                                        System.out.println("\nAerolíneas disponibles:");
                                        System.out.println("-------------------------------------");

                                        int i = 0;
                                        for (Aerolinea objAeroFor : aerolineas) {
                                            i++;
                                            System.out.println(String.valueOf(i) + " - " + objAeroFor.getID() + " --> " + objAeroFor.getNombre());
                                        }

                                        System.out.println("Seleccione la aerolínea que realizará el vuelo");
                                        String opcionUsuario = br.readLine();

                                        try {
                                            opcionAerolinea = Integer.parseInt(opcionUsuario);

                                            if (opcionAerolinea < 0) {
                                                System.out.println("Su opción es inválida");
                                                opcionAerolinea = i + 1;
                                            }
                                        } catch (Exception ex) {
                                            System.out.println("Su opción es inválida");
                                            opcionAerolinea = i + 1;
                                        }

                                        if (opcionAerolinea <= i && opcionAerolinea > 0) {
                                            objAerolineaElegida = aerolineas.get(opcionAerolinea - 1);
                                            opcionAerolinea = 0;

                                            System.out.println("Ingrese el costo del viaje\nCosto mínimo $100");

                                            try {
                                                costoViaje = Integer.parseInt(br.readLine());
                                                if (costoViaje < 1) {
                                                    costoViaje = 100;
                                                }
                                            } catch (Exception ex) {
                                                costoViaje = 100;
                                                System.out.println("Lo ingresado no es un número\nCosto del viaje: $100");
                                            }

                                        } else if (opcionAerolinea != 0) {
                                            System.out.println("Su opción es inválida\nIntente nuevamente");
                                        }
                                    }

                                    if (objAerolineaElegida != null) {
                                        IVuelo vuelo = new Vuelo(aeroPuertoOrigen.getID(), aeroPuertoDestino.getID(), Double.parseDouble(String.valueOf(costoViaje)), objAerolineaElegida.getID());

                                        IArista objArista = new TArista(aeroPuertoOrigen.getID(), aeroPuertoDestino.getID(), vuelo);

                                        if (alita.nuevaArista(objArista)) {
                                            System.out.println("Vuelo insertado satisfactoriamente");
                                        } else {
                                            System.out.println("No se ha podido insertar el vuelo. Intente nuevamente");
                                        }
                                    }
                                }
                            }

                            break;
                        }
                        case 5: {
                            System.out.println("Búsqueda de vuelos entre dos aeropuertos");
                            System.out.println("Ingrese el aeropuerto de origen");
                            String origen = br.readLine();

                            Aeropuerto aeroPuertoOrigen = alita.buscarAeropuerto(origen);

                            if (aeroPuertoOrigen == null) {
                                System.out.println("El aeropuerto no está registrado");
                            } else {
                                System.out.println("Ingrese el aeropuerto de destino");
                                String destino = br.readLine();

                                Aeropuerto aeroPuertoDestino = alita.buscarAeropuerto(destino);

                                if (aeroPuertoDestino == null) {
                                    System.out.println("El aeropuerto no está registrado");
                                } else {
                                    LinkedList<IVuelo> conexiones = alita.buscarVuelos(origen, destino);

                                    if (conexiones != null) {
                                        for (IVuelo objVuelo : conexiones) {
                                            Aerolinea aeroVoladora = alita.buscarAerolinea(objVuelo.getAerolinea());
                                            System.out.println("Aerolínea: " + aeroVoladora.getNombre() + ", Costo $" + objVuelo.getCosto());
                                        }
                                    } else {
                                        System.out.println("No existen vuelos directos entre los aeropuertos ingresados");
                                    }
                                }
                            }

                            break;
                        }
                        case 6: {
                            System.out.println("Ingresar nuevo aeropuerto");
                            System.out.println("Ingrese el código del aeropuerto (3 caracteres de largo)");
                            String aeroCode = br.readLine();

                            Aeropuerto objAeroBuscado = alita.buscarAeropuerto(aeroCode);

                            if (objAeroBuscado != null) {
                                System.out.println("El aeropuerto " + objAeroBuscado.getNombre() + " ingresado ya existe");
                            } else {
                                System.out.println("Ingrese el nombre del aeropuerto");
                                String aeroNombre = br.readLine();

                                Aeropuerto objAeropuerto = new Aeropuerto(aeroCode, aeroNombre);

                                boolean res = alita.nuevoAeropuerto(objAeropuerto);

                                if (res) {
                                    System.out.println("Aeropuerto insertado con éxito!");
                                } else {
                                    System.out.println("Atención. Ha habido un problema con la inserción\nIntente más tarde");
                                }
                            }

                            break;

                        }
                        case 7: {
                            System.out.println("Buscar un aeropuerto");
                            System.out.println("Ingrese el código del aeropuerto");
                            String aeroCode = br.readLine();

                            Aeropuerto objAeroBuscado = alita.buscarAeropuerto(aeroCode);
                            if (objAeroBuscado == null) {
                                System.out.println("El aeropuerto \"" + aeroCode + "\" no existe");
                            } else {
                                System.out.println(objAeroBuscado.imprimir());
                            }

                            break;
                        }
                        case 8: {
                            System.out.println("Buscar un aeropuerto");
                            System.out.println("Ingrese el código del aeropuerto");
                            String aeroCode = br.readLine();

                            Aeropuerto objAeropuerto = alita.buscarAeropuerto(aeroCode);

                            if (objAeropuerto == null) {
                                System.out.println("El aeropuerto \"" + aeroCode + "\" no existe");
                            } else {
                                boolean aeroEliminacion = alita.eliminarAeropuerto(aeroCode);

                                if (aeroEliminacion) {
                                    System.out.println("Aeropuerto eliminado");
                                } else {
                                    System.out.println("No se ha podido eliminar el aeropuerto");
                                }
                            }

                            break;
                        }
                        case 9: {
                            System.out.println("Ingrese el aeropuerto de origen");
                            String origen = br.readLine();

                            Aeropuerto aeroPuertoOrigen = alita.buscarAeropuerto(origen);

                            if (aeroPuertoOrigen == null) {
                                System.out.println("El aeropuerto no está registrado");
                            } else {
                                System.out.println("Ingrese el aeropuerto de destino");
                                String destino = br.readLine();

                                Aeropuerto aeroPuertoDestino = alita.buscarAeropuerto(destino);

                                if (aeroPuertoDestino == null) {
                                    System.out.println("El aeropuerto no está registrado");
                                } else {
                                    int cantEscalas = -1;

                                    System.out.println("Ingrese la cantidad de escalas, entre 1(uno) y 5(cinco)");
                                    try {
                                        cantEscalas = Integer.parseInt(br.readLine());

                                        if (cantEscalas > 5 || cantEscalas < 1) {
                                            cantEscalas = 4;
                                        }
                                    } catch (Exception ex) {
                                        cantEscalas = 4;
                                        System.out.println("Lo ingresado no es un número.\nSe tomarán 4 escalas como máximo");
                                    }

                                    LinkedList<Aerolinea> aerolineas = alita.getAerolineas();
                                    int opcionAerolinea = -1;

                                    if (aerolineas.isEmpty()) {
                                        System.out.println("No hay ninguna aerolínea registrada");
                                    } else {
                                        while (opcionAerolinea != 0) {
                                            System.out.println("Origen: " + aeroPuertoOrigen.getID() + " - " + aeroPuertoOrigen.getNombre());
                                            System.out.println("Destino: " + aeroPuertoDestino.getID() + " - " + aeroPuertoDestino.getNombre());
                                            System.out.println("\nAerolíneas disponibles para viajar:");
                                            System.out.println("-------------------------------------");

                                            int i = 0;
                                            for (Aerolinea objAeroFor : aerolineas) {
                                                i++;
                                                System.out.println(String.valueOf(i) + " - " + objAeroFor.getID() + " --> " + objAeroFor.getNombre());
                                            }

                                            System.out.println("Seleccione la aerolínea en la que desea viajar");
                                            String opcionUsuario = br.readLine();

                                            try {
                                                opcionAerolinea = Integer.parseInt(opcionUsuario);

                                                if (opcionAerolinea < 0) {
                                                    System.out.println("Su opción es inválida");
                                                    opcionAerolinea = i + 1;
                                                }
                                            } catch (Exception ex) {
                                                System.out.println("Su opción es inválida");
                                                opcionAerolinea = i + 1;
                                            }

                                            if (opcionAerolinea <= i && opcionAerolinea > 0) {
                                                Aerolinea objAerolineaElegida = aerolineas.get(opcionAerolinea - 1);

                                                System.out.println("Buscando viajes entre\n" + aeroPuertoOrigen.getNombre() + " y " + aeroPuertoDestino.getNombre() + "\nen la aerolínea " + objAerolineaElegida.getNombre() + " con un máximo de " + cantEscalas + " escalas\n");
                                                //TCaminos muchosCaminitos = alita.todosLosCaminos("LAX", "SLC", 4, "AA");
                                                TCaminos muchosCaminitos = alita.todosLosCaminos(origen, destino, cantEscalas, objAerolineaElegida.getID());

                                                System.out.println("El siguiente es el camino más económico entre las ciudades elegidas");
                                                muchosCaminitos.imprimirCaminoMasCorto();

                                                int cantOpciones = muchosCaminitos.getCaminos().size();

                                                System.out.println("Existen otras " + String.valueOf(cantOpciones - 1) + " posibilidades de vuelo. Ingrese una letra para verlas todas, ENTER para buscar otra aerolínea o 0 (cero) para salir");
                                                String elUsuarioQuiereVerlos = br.readLine();

                                                if (elUsuarioQuiereVerlos.equals("0")) {
                                                    opcionAerolinea = 0;
                                                    System.out.println("AlasUCU desea que disfrute su viaje");
                                                } else if (!elUsuarioQuiereVerlos.equals("")) {
                                                    muchosCaminitos.imprimir();
                                                    System.out.println("ENTER para continuar");
                                                    br.readLine();
                                                }
                                            } else if (opcionAerolinea != 0) {
                                                System.out.println("Su opción es inválida\nIntente nuevamente");
                                            }
                                        }
                                    }
                                }
                            }

                            break;
                        }
                        case 0: {
                            System.out.println(" ----------------------------------------------- ");
                            System.out.println("|                    Bái :D                     |");
                            System.out.println(" ----------------------------------------------- ");

                            break;
                        }
                        default: {
                            System.out.println("Pusiste una opción incorrecta :'(");
                            break;
                        }
                    }
                } catch (Exception ex) {
                    System.out.println(ex.getMessage());
                    System.out.println("Ha habido un error general. Contacte a su administrador para más detalles");
                }
            }

        } catch (Exception ex) {
            System.out.println("El sistema se ha detenido para evitar una explosión de su equipo \n Para más información, contacte al 0993141592");
        }
    }
}
