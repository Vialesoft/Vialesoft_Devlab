/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package FarmaciaPurplePharma;

import java.io.BufferedReader;
import java.io.*;
import java.util.*;
import Clases.*;
import Interfaces.*;
import java.text.*;
import InterFazGraFica.*;

/**
 *
 * @author Lithium582
 */

public class FarmaciaPurplePharma {
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
            //Ventana v = new Ventana();
            //v.show();
            
            Principal p = new Principal();
            p.show();
            
            Farmacia farma = new Farmacia("UCUPharma","Avenida SiempreViva 582","666-333-666");
            // TODO code application logic here
//            
//            ///////////////////////////////////////////////////////////////////////////////
//            Class c = farma.getClass();
//
//            Field f = c.getDeclaredField("direccion");
//            f.setAccessible(true);
//
//            String valueOfMyColor = (String) f.get(farma);
//            
//            System.out.println(valueOfMyColor);
//            BufferedReader bra = new BufferedReader(new InputStreamReader(System.in));
//            bra.readLine();
//            ///////////////////////////////////////////////////////////////////////////////

//            SimpleDateFormat dta = new SimpleDateFormat("dd-MM-yyyy");
//            
//            IArticulo aa = new Articulo(1,dta.parse("01-06-2017 20:00:01"),dta.parse("01-06-2017 20:00:01"),5D,"Hola","Des",true,true,true);
//            IArticulo ab = new Articulo(2,dta.parse("01-06-2017 20:00:01"),dta.parse("01-06-2017 20:00:01"),5D,"Chau","Des",true,true,true);
//            IArticulo ac = new Articulo(6,dta.parse("01-06-2017 20:00:01"),dta.parse("01-06-2017 20:00:01"),5D,"Hoau","Algo",true,true,true);
//            IArticulo ad = new Articulo(8,dta.parse("01-06-2017 20:00:01"),dta.parse("01-06-2017 20:00:01"),5D,"Hoau","Algo",true,true,true);
//            IArticulo ae = new Articulo(12,dta.parse("01-06-2017 20:00:01"),dta.parse("01-06-2017 20:00:01"),5D,"Hoau","Algo",true,true,true);
//            IArticulo af = new Articulo(16,dta.parse("01-06-2017 20:00:01"),dta.parse("01-06-2017 20:00:01"),5D,"Hoau","Algo",true,true,true);
//            IArticulo ag = new Articulo(25,dta.parse("01-06-2017 20:00:01"),dta.parse("01-06-2017 20:00:01"),5D,"Hoau","Algo",true,true,true);
//            
//            INodoArbol<IArticulo> nodo = new NodoArbol<IArticulo>(aa.getID(),aa);
//            INodoArbol<IArticulo> nodo2 = new NodoArbol<IArticulo>(ab.getID(),ab);
//            INodoArbol<IArticulo> nodo3 = new NodoArbol<IArticulo>(ac.getID(),ac);
//            INodoArbol<IArticulo> nodo4 = new NodoArbol<IArticulo>(ad.getID(),ad);
//            INodoArbol<IArticulo> nodo5 = new NodoArbol<IArticulo>(ae.getID(),ae);
//            INodoArbol<IArticulo> nodo6 = new NodoArbol<IArticulo>(af.getID(),af);
//            INodoArbol<IArticulo> nodo7 = new NodoArbol<IArticulo>(ag.getID(),ag);
//            
//            IArbol<IArticulo> arbol = new Arbol<IArticulo>(nodo);
//            arbol.insertar(nodo2);
//            arbol.insertar(nodo3);
//            arbol.insertar(nodo4);
//            arbol.insertar(nodo5);
//            arbol.insertar(nodo6);
//            arbol.insertar(nodo7);
            
            //String strA = arbol.buscarXAtributo("nombre", "Ho");
            //String strB = arbol.buscarXAtributo("descripcion", "es");
            
//            System.out.println(strA);
//            System.out.println(strB);

//            ILista<IArticulo> lista = new Lista<IArticulo>();
//            arbol.buscarInRango(2, 16, lista);
//            
//            System.out.println(lista.Print());
//
//            BufferedReader bra = new BufferedReader(new InputStreamReader(System.in));
//            bra.readLine();

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
                System.out.println(" -------- Cargar Archivos CSV -------- ");
                System.out.println("1 - Cargar Artículos");
                System.out.println("2 - Cargar Stock");
                System.out.println(" ------------- Artículos ------------- ");
                System.out.println("3 - Nuevo");
                System.out.println("4 - Listar Todos");
                System.out.println("5 - Buscar");
                System.out.println("6 - Eliminar");
                System.out.println(" ------------ Movimientos ------------ ");
                System.out.println("7 - Nueva venta");
                System.out.println("8 - Devolver una venta");
                System.out.println("9 - Reportes");
                System.out.println(" ------------------------------------ ");
                System.out.println("10 - Información");
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
                        System.out.println("\t0 para cargar el archivo por defecto farmacia_articles_small.csv");
                        String direccion = br.readLine().trim();
                        if (direccion.equals("0")){
                            direccion = "farmacia_articles_small.csv";
                        }
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
                        System.out.println("\t0 para cargar el archivo por defecto farmacia_stock_small.csv");
                        String direccion = br.readLine().trim();
                        if (direccion.equals("0")){
                            direccion = "farmacia_stock_small.csv";
                        }
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

                            System.out.println("Ingrese el área del artículo");
                            String pArea = br.readLine().trim();
                            
                            System.out.println("Ingrese el año de vencimiento del artículo");
                            Integer pAnoVenc = Integer.parseInt(br.readLine().trim());
                            
                            Articulo objArticulo = new Articulo(pID,pFechaCreacion,pFechaActualizacion,pPrecio,pNombre,pDescripcion,pAnoVenc,true,pRefrigeracion,pReceta);
                            if (farma.InsertarArticulo(objArticulo, pArea)){
                                System.out.println("Artículo ingresado con éxito");
                            }
                        }
                        catch(Exception ex){
                            System.out.println("Opción incorrecta");
                        }
                        
                        break;
                    }
                    case 4:{
                        String retorno = farma.retornarArticulos("");
//                        String hola = farma.retornarInOrden();
//                        System.out.println(hola);
                        //String retorno = farma.retornarArticulos();
                        if (!retorno.equals("")){
                            System.out.println(retorno);
                        }else{
                            System.out.println("No hay artículos en la lista");
                        }
                        
                        break;
                    }
                    case 5:{
                        try{
                            System.out.println("Ingrese su opción de búsqueda");
                            System.out.println("0 - Cantidad de Artículos");
                            System.out.println("1 - Buscar por ID de artículo");
                            System.out.println("2 - Buscar por nombre de artículo");
                            System.out.println("3 - Buscar por descripción de artículo");
                            System.out.println("4 - Buscar por artículos por año de vencimiento");
                            System.out.println("5 - Buscar por área de aplicación");
                            Integer subOP = Integer.parseInt(br.readLine());

                            switch(subOP){
                                case 0:{
                                    Integer intObt = farma.CantidadDeArticulos();
                                    
                                    if (intObt == -1){
                                        System.out.println("La farmacia no posee artículos");
                                    }else{
                                        System.out.println("La farmacia posee " + intObt.toString() + " artículos distintos");
                                    }
                                    
                                    break;
                                }
                                case 1:{
                                    System.out.println("Ingrese el ID del producto buscado");
                                    Integer idBusqueda = Integer.parseInt(br.readLine());
                                    
                                    String[] areaProducto = new String[1];
                                    IArticulo a = farma.BuscarArticuloXID(idBusqueda, areaProducto);
                                    
                                    if (a == null){
                                        System.out.println("Artículo inexistente");
                                    }
                                    else{
                                        System.out.println("Área " + areaProducto[0].toUpperCase());
                                        System.out.println(a.toString());
                                    }
                                    
                                    break;
                                }
                                case 2:{
                                    System.out.println("Ingrese el nombre del producto buscado");
                                    String nomBusqueda = (br.readLine());
                                    
                                    ILista<IArticulo> a = farma.listarXNombre(nomBusqueda);
                                    
                                    if (a == null || a.CantidadDeElementos() == 0){
                                        System.out.println("Artículos inexistentes");
                                    }
                                    else{
                                        System.out.println(a.Print("-"));
                                    }
                                    
                                    break;
                                }
                                case 3:{
                                    System.out.println("Ingrese la descripción del producto buscado");
                                    String descBusqueda = (br.readLine());
                                    
                                    ILista<IArticulo> a = farma.listarXDescripcion(descBusqueda);
                                    
                                    if (a == null  || a.CantidadDeElementos() == 0){
                                        System.out.println("Artículos inexistentes");
                                    }
                                    else{
                                        System.out.println(a.Print("-"));
                                    }
                                    
                                    break;
                                }
                                case 4:{
                                    System.out.println("Ingrese el año de Vencimiento");
                                    String anoBuscado = (br.readLine());
                                    
                                    ILista<IArticulo> a = farma.buscarArticulosXAnoVencimiento(anoBuscado);
                                    
                                    if (a == null || a.CantidadDeElementos() == 0){
                                        System.out.println("No hay artículos con vencimiento en " + anoBuscado);
                                    }
                                    else{
                                        System.out.println(a.Print("-"));
                                    }
                                    
                                    break;
                                }
                                case 5:{
                                    System.out.println("Ingrese el área de Aplicación buscada");
                                    String areaBuscada = br.readLine();
                                    
                                    String strArticulos = farma.listarArticulosXArea(areaBuscada);
                                    
                                    if (strArticulos.equals("")){
                                        System.out.println("El área " + areaBuscada + " no existe");
                                    }
                                    else{
                                        System.out.println(strArticulos);
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
                        System.out.println("Eliminar");
                        System.out.println("1 - Eliminar artículo por ID");
                        System.out.println("2 - Eliminar artículos por área");
                        Integer op6 = Integer.parseInt(br.readLine());
                        
                        switch(op6){
                            case 1:{
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
                            case 2:{
                                System.out.println("Ingrese el área a borrar");
                                String areaBorrar = br.readLine();

                                Boolean bBorrado = farma.EliminarArea(areaBorrar);
                                if (bBorrado){
                                    System.out.println("Área eliminada con éxito");
                                }
                                else{
                                    System.out.println("No se ha podido eliminar el área");
                                }
                                
                                break;
                            }
                        }
                        
                        break;
                    }
                    case 7:{
                        System.out.println("Ingrese el ID del producto a vender");
                        Integer idBuscar = Integer.parseInt(br.readLine());
                        
                        String[] areaProducto = new String[1];
                        IArticulo objArticulo = farma.BuscarArticuloXID(idBuscar, areaProducto);
                        
                        if (objArticulo == null){
                            System.out.println("El artículo no se ha podido encontrar");
                        }
                        else if(objArticulo.getStock() == 0){
                            System.out.println("El artículo no cuenta con stock");
                        }
                        else{
                            System.out.println("Artículo encontrado");
                            System.out.println("Área " + areaProducto[0].toUpperCase());
                            System.out.println(objArticulo.toString());
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
                            
                            Movimiento objVenta = new Movimiento(objArticulo,intCantidad);
                            
                            if(farma.GuardarVenta(objVenta,areaProducto[0])){
                                System.out.println("Venta N° " + objVenta.getID().toString() + " realizada con éxito\nUCUPharma agradece su compra :D");
                            }else{
                                System.out.println("No ha podido realizarse la venta");
                            }
                        }
                        
                        break;
                    }
                    case 8:{
                        System.out.println("Ingrese el ID de la venta que se quiere devolver");
                        Long idVentaBuscar = Long.parseLong(br.readLine());
                        
                        if (farma.ReintegroVenta(idVentaBuscar)){
                            System.out.println("Venta reintegrada con éxito");
                        }
                        else{
                            System.out.println("La venta no pudo reintegrarse");
                        }
                        
                        break;
                    }
                    case 9:{
                        System.out.println("Listar Ventas"
                                + "\n0 - Listar todas"
                                + "\n1 - Reportes por fecha"
                                + "\n2 - Ventas de un producto"
                                + "\n3 - Movimientos por área"
                                + "\n4 - Promedio de ventas mensuales");
                        Integer op3 = Integer.parseInt(br.readLine());
                        
                        switch(op3){
                            case 0:{
                                String retorno = farma.retornarVentas("-");
                            
                                if (retorno.equals("") || retorno == null){
                                    System.out.println("No hay ventas ingresadas");
                                }else{
                                    System.out.println(retorno);
                                }
                            
                                break;
                            }
                            case 1:{
                                System.out.println("Las fechas se ingresan en formato dd-MM-yyyy\nEjemplo: 25-08-2016");
                                System.out.println("Ingrese la primera fecha");
                                String fecha1 = br.readLine();
                                System.out.println("Ingrese la segunda fecha");
                                String fecha2 = br.readLine();

                                SimpleDateFormat dt = new SimpleDateFormat("dd-MM-yyyy");

                                try{
                                    Date dateFecha1 = dt.parse(fecha1);
                                    Date dateFecha2 = dt.parse(fecha2);
                                    dateFecha2.setTime(dateFecha2.getTime() + 86400000L);

                                    ILista<IMovimiento> listaVentas = farma.ListadoVenta(dateFecha1.getTime(), dateFecha2.getTime());

                                    if (listaVentas == null){
                                        System.out.println("No hay ventas en ese rango de fechas");
                                    }
                                    else{
                                        System.out.println(listaVentas.Print("-"));
                                    }
                                }
                                catch(Exception ex){
                                    System.out.println("Las fechas son inválidas. Verifique el formato requerido!");
                                }
                                
                                break;
                            }
                            case 2:{
                                System.out.println("Ingrese el ID del producto buscado");
                                Integer idProd = Integer.parseInt(br.readLine());
                                
                                ILista<IMovimiento> listaVentas = farma.buscarVentasXProducto(idProd);
                                
                                if (listaVentas == null){
                                    System.out.println("No hay ventas ingresadas");
                                }else{
                                    System.out.println(listaVentas.Print("-"));
                                }
                                
                                break;
                            }
                            case 3:{
                                System.out.println("Ingrese el área de Aplicación buscada");
                                String areaBuscada = br.readLine();
                                    
                                String strArticulosVenta = farma.listarVentasXArea(areaBuscada);
                                    
                                if (strArticulosVenta.equals("")){
                                    System.out.println("No hay ventas en " + areaBuscada);
                                }
                                else{
                                    System.out.println("Ventas del área " + strArticulosVenta);
                                    //System.out.println(strArticulosVenta);
                                }
                                
                                String strArticulosCompra = farma.listarComprasXArea(areaBuscada);
                                    
                                if (strArticulosCompra.equals("")){
                                    System.out.println("No hay compras en " + areaBuscada);
                                }
                                else{
                                    System.out.println("Compras del área " + strArticulosCompra);
                                    //System.out.println(strArticulosCompra);
                                }
                                    
                                break;
                            }
                            case 4:{
                                System.out.println("Ingrese el ID del artículo buscado");
                                Integer idArticuloBuscado = Integer.parseInt(br.readLine());
                                
                                Double promedio = farma.promedioVentasXArticulo(idArticuloBuscado);
                                
                                if(promedio.equals(0D)){
                                    System.out.println("No hay ventas realizadas para el artículo " + idArticuloBuscado.toString());
                                }
                                else{
                                    System.out.println("El promedio de ventas del artículo " + idArticuloBuscado.toString() + " es de " + promedio.toString());
                                }
                            
                                break;
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
                System.out.println("El sistema se ha detenido para evitar una explosión de su equipo \n Para más información, contacte al 0993141592");
            }
    }
}
