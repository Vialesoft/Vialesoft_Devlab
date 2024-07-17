/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package farmaciaucupharma;

import java.util.ArrayList;
import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.util.*;
import java.time.*;
import Clases.*;
import Interfaces.*;
import java.text.*;

/**
 *
 * @author Lithium582
 */

public class FarmaciaUCUPharma {
/*
    DateFormat d = new SimpleDateFormat("yyyy/MM/dd HH:mm:ss");
    Calendar cal = Calendar.getInstance();
    System.out.println(d.format(cal.getTime()));
    System.out.println(cal.getTime());
*/
    /**
     * @param args the command line arguments
    **/
    public static void main(String[] args) {
        try{
            Farmacia farma = new Farmacia("UCUPharma","Wall Street 1929","666-666-6666");
            // TODO code application logic here

            Integer op = -1;
            Boolean b = false;

            while(op != 0){
                try{
                BufferedReader br = new BufferedReader(new InputStreamReader(System.in));
                if (b){
                    System.out.println("\n ------------------------------ ");
                    System.out.println(" .... ENTER para continuar .... ");
                    System.out.println(" ------------------------------ ");
                    br.readLine();
                }
                else{
                    b = !b;
                }
                
                System.out.println("Bienvenido/a a UCUPharma\nIngrese una opción para continuar:");
                System.out.println(" ------------------------------------ ");
                System.out.println("1 - Cargar Artículos desde archivo CSV");
                System.out.println("2 - Cargar Stock desde archivo CSV");
                System.out.println(" ------------------------------------ ");
                System.out.println("3 - Crear un nuevo Artículo");
                System.out.println("4 - Listar todos los artículos");
                System.out.println("5 - Buscar Artículos");
                System.out.println("6 - Eliminar un artículo");
                System.out.println(" ------------------------------------ ");
                System.out.println("7 - Realizar una venta");
                System.out.println("8 - Devolución");
                System.out.println("9 - Reportes");
                System.out.println("10 - Información");
                System.out.println(" ------------------------------------ ");
                System.out.println("0 - SALIR");
                System.out.print("Ingrese una opción \n");
                
                try{
                    op = Integer.parseInt(br.readLine());
                }
                catch(Exception ex){
                    op = -1;
                    System.out.println("Opción incorrecta");
                }
                
                switch(op){
                    case 1:{
                        System.out.println("Cargando archivo");
                        
                        System.out.println("Ingrese la dirección del archivo");
                        String direccion = br.readLine().trim();
                        Boolean bool = farma.cargarArticulos(direccion);
                        
                        if(bool){
                            System.out.println("El archivo ha sido cargado con éxito");
                        }
                        
                        //System.out.println(farma.getArticulos().Print());
                        break;
                    }
                    case 2:{
                        System.out.println("Cargando archivo");
                        
                        System.out.println("Ingrese la dirección del archivo");
                        String direccion = br.readLine().trim();
                        Boolean bool = farma.cargarStock(direccion);
                        
                        if(bool){
                            System.out.println("El archivo ha sido cargado con éxito");
                        }
                        
                        //System.out.println(farma.getArticulos().Print());
                        break;
                    }
                    case 3:{
                        try{
                            System.out.println("Ingrese el ID del artículo");
                            Integer pID = Integer.parseInt(br.readLine().trim());

                            System.out.println("Ingrese el precio del artículo");
                            Double pPrecio = Double.parseDouble(br.readLine().trim());

                            System.out.println("Ingrese el nombre del artículo");
                            String pNombre = br.readLine().trim();

                            System.out.println("Ingrese la descripción del artículo");
                            String pDescripcion = br.readLine().trim();

                            System.out.println("El artículo necesita refrigeración?\n1 para si\n0 para no");
                            String strRefri = br.readLine().trim();
                            boolean pRefrigeracion = (!(strRefri.equals("0")));

                            System.out.println("El artículo necesita receta?\n1 para si\n0 para no");
                            String strReceta = br.readLine().trim();
                            boolean pReceta = (!(strReceta.equals("0")));

                            Date pFechaCreacion = Calendar.getInstance().getTime();
                            Date pFechaActualizacion = Calendar.getInstance().getTime();

                            Articulo objArticulo = new Articulo(pID,pFechaCreacion,pFechaActualizacion,pPrecio,pNombre,pDescripcion,true,pRefrigeracion,pReceta);
                            if (farma.InsertarArticulo(objArticulo)){
                                System.out.println("Artículo ingresado con éxito");
                            }
                        }
                        catch(Exception ex){
                            System.out.println("Opción incorrecta");
                        }
                        
                        break;
                    }
                    case 4:{
                        String retorno = farma.retornarArticulos("-");
                        if (retorno != ""){
                            System.out.println(retorno);
                        }else{
                            System.out.println("No hay artículos en la lista");
                        }
                        
                        break;
                    }
                    case 5:{
                        try{
                            System.out.println("Ingrese su opción de búsqueda");
                            System.out.println("1 - Buscar por ID de artículo");
                            System.out.println("2 - Buscar por nombre de artículo");
                            System.out.println("3 - Buscar por descripción de artículo");
                            Integer subOP = Integer.parseInt(br.readLine());

                            switch(subOP){
                                case 1:{
                                    System.out.println("Ingrese el ID del producto buscado");
                                    Integer idBusqueda = Integer.parseInt(br.readLine());
                                    
                                    IArticulo a = farma.BuscarXID(idBusqueda);
                                    
                                    if (a == null){
                                        System.out.println("Artículo inexistente");
                                    }
                                    else{
                                        System.out.println(a.toString("-"));
                                    }
                                    
                                    break;
                                }
                                case 2:{
                                    System.out.println("Ingrese el nombre del producto buscado");
                                    String nomBusqueda = (br.readLine());
                                    
                                    String a = farma.buscarXNombre(nomBusqueda);
                                    
                                    if (a.equals("") || a == null){
                                        System.out.println("Artículo inexistente");
                                    }
                                    else{
                                        System.out.println(a);
                                    }
                                    
                                    break;
                                }
                                case 3:{
                                    System.out.println("Ingrese la descripción del producto buscado");
                                    String descBusqueda = (br.readLine());
                                    
                                    String a = farma.buscarXDescripcion(descBusqueda);
                                    
                                    if (a.equals("") || a == null){
                                        System.out.println("Artículo inexistente");
                                    }
                                    else{
                                        System.out.println(a);
                                    }
                                    
                                    break;
                                }
                            }
                        }
                        catch(Exception ex){
                            System.out.println("Opción incorrecta");
                        }
                        break;
                    }
                    case 6:{
                        System.out.println("Ingrese el ID del producto a borrar");
                        Integer idBorrar = Integer.parseInt(br.readLine());
                        
                        Boolean bBorrado = farma.EliminarArticulo(idBorrar);
                        if (bBorrado){
                            System.out.println("Artículo eliminado con éxito");
                        }
                        else{
                            System.out.println("No se ha podido eliminar el artículo");
                        }
                        
                        break;
                    }
                    case 7:{
                        System.out.println("Ingrese el ID del producto a vender");
                        Integer idBuscar = Integer.parseInt(br.readLine());
                        
                        IArticulo objArticulo = farma.BuscarXID(idBuscar);
                        
                        if (objArticulo == null){
                            System.out.println("El artículo no se ha podido encontrar");
                        }
                        else if(objArticulo.getStock() == 0){
                            System.out.println("El artículo no cuenta con stock");
                        }
                        else{
                            System.out.println("Artículo encontrado");
                            System.out.println(objArticulo.toString("-"));
                            System.out.println("Ingrese la cantidad de artículos que quiere vender");
                            Integer intCantidad = Integer.parseInt(br.readLine());
                            Integer stock = objArticulo.getStock();
                            
                            if (stock >= intCantidad){
                                objArticulo.setStock(stock - intCantidad);
                            }
                            else{
                                System.out.println("El stock no es suficiente. Se ha realizado la venta de " + objArticulo.getStock() + " artículo");
                                intCantidad = stock;
                                objArticulo.setStock(0);
                            }
                            
                            Venta objVenta = new Venta(objArticulo,intCantidad);
                            
                            if(farma.GuardarVenta(objVenta)){
                                System.out.println("Venta N° " + objVenta.getID().toString() + " realizada con éxito\nUCUPharma agradece su compra :D");
                            }else{
                                System.out.println("No ha podido realizarse la venta");
                            }
                        }
                        
                        break;
                    }
                    case 8:{
                        System.out.println("Ingrese el ID de la venta que se quiere devolver");
                        Integer idVentaBuscar = Integer.parseInt(br.readLine());
                        
                        if (farma.ReintegroVenta(idVentaBuscar)){
                            System.out.println("Venta reintegrada con éxito");
                        }
                        else{
                            System.out.println("La venta no pudo reintegrarse");
                        }
                        
                        break;
                    }
                    case 9:{
                        System.out.println("Listar Ventas\n0 - Listar todas\n1 - Reportes por fecha");
                        Integer op3 = Integer.parseInt(br.readLine());
                        
                        if (op3 == 0){
                            String retorno = farma.retornarVentas("-");
                            
                            if (retorno.equals("") || retorno == null){
                                System.out.println("No hay ventas ingresadas");
                            }else{
                                System.out.println(retorno);
                            }
                            
                        }
                        else{
                            System.out.println("Las fechas se ingresan en formato dd-MM-yyyy\nEjemplo: 25/08/2016");
                            System.out.println("Ingrese la primera fecha");
                            String fecha1 = br.readLine();
                            System.out.println("Ingrese la segunda fecha");
                            String fecha2 = br.readLine();
                            
                            SimpleDateFormat dt = new SimpleDateFormat("dd-MM-yyyy");
                            
                            try{
                                Date dateFecha1 = dt.parse(fecha1);
                                Date dateFecha2 = dt.parse(fecha2);
                            
                                String ventas = farma.ListadoVenta(dateFecha1, dateFecha2);

                                if (ventas == "" || ventas == null){
                                    System.out.println("No hay ventas en ese rango de fechas");
                                }
                                else{
                                    System.out.println(ventas);
                                }
                            }
                            catch(Exception ex){
                                System.out.println("Las fechas son inválidas. Verifique el formato requerido!");
                            }
                        }
                                                
                        break;
                    }
                    case 10:{
                        System.out.println("--------------------------------------------------------------------------------");
                        System.out.println("Sistema desarrollado por Lithium582 Software Solutions especialmente para");
                        System.out.println(farma.getNombre() + " Sociedad Farmacéutica de Capital Variable");
                        System.out.println("Teléfono: " + farma.getTelefono());
                        System.out.println("Dirección: " + farma.getDireccion());
                        System.out.println("--------------------------------------------------------------------------------");
                        break;
                    }
                    case 0:{
                        System.out.println("----------");
                        System.out.println("| Bái :D |");
                        System.out.println("----------");
                        br.readLine();
                        
                        break;
                    }
                    default:{
                        System.out.println("Pusiste una opción incorrecta :'(");
                        break;
                    }
                }
            }
            catch(Exception ex){
                    System.out.println("Ha habido un error general. Contacte a su administrador para más detalles");
            }
            }
            
        }
            catch(Exception ex){
                System.out.println("El sistema se ha detenido para evitar una explosión de su equipo");
            }
    }
}
