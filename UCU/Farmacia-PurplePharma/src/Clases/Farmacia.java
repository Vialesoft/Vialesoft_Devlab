/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package Clases;
import Interfaces.*;
import java.util.*;
import java.text.*;
import javax.swing.JOptionPane;

/**
 *
 * @author Lithium582
 */
public class Farmacia implements IFarmacia {
    
    // <editor-fold defaultstate="extended" desc="Atributos">
        private final String nombre;
        private String direccion;
        private String telefono;
        //Productos en STOCK
        private final Lista<IArbol<IArticulo>> listaArticulos;
        //Ventas realizadas
        private final Lista<IArbol<IMovimiento>> listaVentas;
        //Compras realizadas
        private final Lista<IArbol<IMovimiento>> listaCompras;
    // </editor-fold>
    
    // <editor-fold defaultstate="extended" desc="Constructores">
    
    /**
     * Constructor de Farmacia
     */
    public Farmacia(){
        this.nombre = "Purple Pharma";
        this.direccion = "Avenida Siempreviva 1234";
        this.telefono = "666-333-666";
        this.listaArticulos = new Lista<IArbol<IArticulo>>();
        this.listaVentas = new Lista<IArbol<IMovimiento>>();
        this.listaCompras = new Lista<IArbol<IMovimiento>>();
    }
    
    /**
     * Constructor de Farmacia
     * @param pNombre Nombre de la Farmacia
     * @param pDireccion Direccion de la Farnacia
     * @param pTelefono Teléfono de la Farnacia
    **/
    public Farmacia(String pNombre, String pDireccion, String pTelefono){
        this.nombre = pNombre;
        this.direccion = pDireccion;
        this.telefono = pTelefono;
        this.listaArticulos = new Lista<IArbol<IArticulo>>();
        this.listaVentas = new Lista<IArbol<IMovimiento>>();
        this.listaCompras = new Lista<IArbol<IMovimiento>>();
    }

    // </editor-fold>
    
    // <editor-fold defaultstate="extended" desc="Propiedades">
    @Override
    public String getDireccion() {
        return this.direccion;
    }

    @Override
    public void setDireccion(String value) {
        this.direccion = value;
    }

    @Override
    public String getTelefono() {
        return this.telefono;
    }

    @Override
    public void setTelefono(String value) {
        this.telefono = value;
    }

    @Override
    public String getNombre() {
        return this.nombre;
    }

    @Override
    public Lista<IArbol<IArticulo>> getArticulos() {
        return this.listaArticulos;
    }

    @Override
    public Lista<IArbol<IMovimiento>> getVentas() {
        return this.listaVentas;
    }

    // </editor-fold>
    
    // <editor-fold defaultstate="extended" desc="Métodos y Funciones">
    @Override
    public Boolean cargarArticulos(String rutaArchivo) {
        Integer cantErroneos = 0;
        Integer cantVencidos = 0;
        
        ArrayList<String> elementos = ManejadorArchivosGenerico.leerArchivo(rutaArchivo);
        elementos.remove(0);
        Collections.shuffle(elementos);
        
        for (int i = 1; i < elementos.size(); i++){
            String[] linea = elementos.get(i).split(";");
            
            if (linea.length == 11){
                try{
                    Comparable id = Integer.parseInt(linea[0].trim());
                    Date fecha_Creacion = FormatoFecha(linea[1].trim());
                    Date fecha_Actualizacion = FormatoFecha(linea[2].trim());
                    double precio =  Double.parseDouble((linea[3].trim()));
                    String nombre = linea[4].trim();
                    String descripcion = linea[5].trim();
                    Boolean estado = VerificarEstado(linea[6].trim());
                    boolean refrigerado = VerificarBooleano(linea[7].trim());
                    boolean receta = VerificarBooleano(linea[8].trim());
                    Integer anoVencimiento = Integer.parseInt(linea[9].trim());
                    String areaAplicacion = RemoverCaracteres(linea[10].trim()).toUpperCase();

                    IArticulo a = new Articulo(id,fecha_Creacion,fecha_Actualizacion,precio,nombre,descripcion,anoVencimiento,estado,refrigerado,receta);
                    
                    if (anoVencimiento < new GregorianCalendar().get(Calendar.YEAR)){
                        cantVencidos++;
                    }else{
                        this.InsertarArticulo(a,areaAplicacion);
                    }
                }
                catch(Exception ex){
                    cantErroneos++;
                }
            }else{
                cantErroneos++;
            }
        }
        
        if (cantErroneos > 0){
            //System.out.println("Se han omitido " + cantErroneos + " registros incorrectos");
            JOptionPane.showMessageDialog(null, "Se han omitido " + cantErroneos + " registros incorrectos", "Atención", JOptionPane.WARNING_MESSAGE);
        }
        if (cantVencidos > 0){
            //System.out.println("Se han omitido " + cantErroneos + " registros incorrectos");
            JOptionPane.showMessageDialog(null, "Se han omitido " + cantVencidos + " artículos vencidos", "Atención", JOptionPane.WARNING_MESSAGE);
        }
        
        if (elementos.size() == 0){
            return false;
        }
        
        return true;
    }
    
    @Override
    public Boolean cargarStock(String rutaArchivo) {
        Integer cantErroneos = 0;
        ArrayList<String> elementos = ManejadorArchivosGenerico.leerArchivo(rutaArchivo);
        
        for (int i = 1; i < elementos.size(); i++){
            String[] linea = elementos.get(i).split(";");
            
            if (linea.length == 2){
                Integer idArticulo = Integer.parseInt(linea[0].trim());
                Integer stock = Integer.parseInt(linea[1].trim());
                String strArea[] = new String[1];
                
                IArticulo objArticulo = BuscarArticuloXID(idArticulo,strArea);
                
                if(objArticulo != null){
                    Integer stockActual = objArticulo.getStock();
                    objArticulo.setStock(stockActual + stock);
                    Movimiento objCompra = new Movimiento(objArticulo,stock);
                    
                    INodoLista<IArbol<IMovimiento>> objNodoLista = this.listaCompras.Buscar(strArea[0]);
                    INodoArbol<IMovimiento> nodoNuevo = new NodoArbol<IMovimiento>(objCompra.getID(),objCompra);
                    
                    if (objNodoLista == null){
                        IArbol<IMovimiento> objNuevoArbol = new Arbol<IMovimiento>(nodoNuevo);
                        objNodoLista = new NodoLista<IArbol<IMovimiento>>(objNuevoArbol, strArea[0]);
                    
                        listaCompras.Insertar(objNodoLista);
                    }
                    else{
                        objNodoLista.getObjeto().insertar(nodoNuevo);
                    }
                }
                else{
                    cantErroneos++;
                }
                
            }else{
                cantErroneos++;
            }
        }
        
        if (cantErroneos > 0){
            //System.out.println("Se han omitido " + cantErroneos + " registros incorrectos");
            JOptionPane.showMessageDialog(null, "Se han omitido " + cantErroneos + " registros incorrectos", "Atención", JOptionPane.WARNING_MESSAGE);
        }
        
        if (elementos.size() == 0){
            return false;
        }
        
        return true;
    }

    @Override
    public IArticulo BuscarArticuloXID(Comparable pId, String[] pAreaProducto) {
       if (listaArticulos.esVacia()) {
            return null;
       }
       else {
            INodoLista<IArbol<IArticulo>> nodoActual = listaArticulos.getPrimero();
            
            while(nodoActual != null){
                INodoArbol<IArticulo> nodoArbol = nodoActual.getObjeto().buscar(pId);
                
                if(nodoArbol != null){
                    IArticulo prodBuscado = nodoArbol.getDatos();
                    pAreaProducto[0] = nodoActual.getEtiqueta().toString();
                    return prodBuscado;
                }
                nodoActual = nodoActual.getSiguiente();
            }
       }
       
       return null;
    }
    
    @Override
    public String buscarXDescripcion(String pDescripcion) {
        if (listaArticulos.esVacia()) {
            return "";
       }
       else {
            INodoLista<IArbol<IArticulo>> nodoActual = listaArticulos.getPrimero();
            String str = "";
            while(nodoActual != null){
                str += nodoActual.getObjeto().buscarXAtributo("descripcion", pDescripcion);
                
                nodoActual = nodoActual.getSiguiente();
            }
            
            return str;
       }
    }
    
    @Override
    public Integer CantidadDeArticulos() {
        if (listaArticulos.esVacia()) {
            return -1;
       }
       else {
            INodoLista<IArbol<IArticulo>> nodoActual = listaArticulos.getPrimero();
            Integer intRetorno = 0;
            while(nodoActual != null){
                intRetorno += nodoActual.getObjeto().getTamano();
                
                nodoActual = nodoActual.getSiguiente();
            }
            
            return intRetorno;
       }
    }
    
    @Override
    public ILista<IArticulo> listarXDescripcion(String pDescripcion) {
        if (listaArticulos.esVacia()) {
            return null;
       }
       else {
            ILista<IArticulo> listaRetorno = new Lista<IArticulo>();
            INodoLista<IArbol<IArticulo>> nodoActual = listaArticulos.getPrimero();
            
            while(nodoActual != null){
                nodoActual.getObjeto().buscarXAtributo("descripcion", pDescripcion,listaRetorno);
                
                nodoActual = nodoActual.getSiguiente();
            }
            
            return listaRetorno;
       }
    }
    
    @Override
    public String buscarXNombre(String pNombre) {
        if (listaArticulos.esVacia()) {
            return "";
       }
       else {
            INodoLista<IArbol<IArticulo>> nodoActual = listaArticulos.getPrimero();
            String str = "";
            while(nodoActual != null){
                str += nodoActual.getObjeto().buscarXAtributo("nombre", pNombre);
                
                nodoActual = nodoActual.getSiguiente();
            }
            
            return str;
       }
    }

    @Override
    public ILista<IArticulo> listarXNombre(String pNombre){
        if (listaArticulos.esVacia()) {
            return null;
       }
       else {
            ILista<IArticulo> listaRetorno = new Lista<IArticulo>();
            INodoLista<IArbol<IArticulo>> nodoActual = listaArticulos.getPrimero();
            
            while(nodoActual != null){
                nodoActual.getObjeto().buscarXAtributo("nombre", pNombre, listaRetorno);
                
                nodoActual = nodoActual.getSiguiente();
            }
            
            return listaRetorno;
       }
    }
    
    @Override
    public ILista<IArticulo> buscarArticulosXAnoVencimiento(String pAnoVencimiento) {
       if (listaArticulos.esVacia()) {
            return null;
       }
       else {
            ILista<IArticulo> listaRetorno = new Lista<IArticulo>();
            INodoLista<IArbol<IArticulo>> nodoActual = listaArticulos.getPrimero();
            
            while(nodoActual != null){
                nodoActual.getObjeto().buscarXAtributo("anoVencimiento", pAnoVencimiento, listaRetorno);
                
                nodoActual = nodoActual.getSiguiente();
            }
            
            return listaRetorno;
       }
    }
    
    @Override
    public Boolean InsertarArticulo(IArticulo pArticulo, Comparable pArea) {
        INodoLista<IArbol<IArticulo>> nodoBuscado = this.listaArticulos.Buscar(pArea);
        
        if (nodoBuscado == null){
            //Significa que el área no existe
            //Generamos el árbol y luego insertamos ese árbol a la lista
            INodoArbol objNodoArbol = new NodoArbol(pArticulo.getID(), pArticulo);
            IArbol objArbol = new Arbol(objNodoArbol);
            
            INodoLista<IArbol<IArticulo>> objLista = new NodoLista<IArbol<IArticulo>>(objArbol, pArea);
            
            this.listaArticulos.Insertar(objLista);
            return true;
        } else{
            INodoArbol<IArticulo> nodoArbolLista = nodoBuscado.getObjeto().buscar(pArticulo.getID());
            
            if (nodoArbolLista == null){
                INodoArbol<IArticulo> nuevoArticulo = new NodoArbol<IArticulo>(pArticulo.getID(),pArticulo);
                nodoBuscado.getObjeto().insertar(nuevoArticulo);
                return true;
            }
            else{
                IArticulo objEncontrado = nodoArbolLista.getDatos();
                
                objEncontrado.setDescripcion(pArticulo.getDescripcion());
                objEncontrado.setEstado(pArticulo.getEstado());
                objEncontrado.setFechaActualizacion(Calendar.getInstance().getTime());
                objEncontrado.setNombre(pArticulo.getNombre());
                objEncontrado.setPrecio(pArticulo.getPrecio());
                objEncontrado.setReceta(pArticulo.getReceta());
                objEncontrado.setRefrigerado(pArticulo.getRefrigerado());
                objEncontrado.setStock(pArticulo.getStock());
            }
            
            return true;
        }
    }

    @Override
    public Boolean EliminarArticulo(Comparable pId) {
        INodoLista<IArbol<IArticulo>> aux = listaArticulos.getPrimero();
        while (aux != null) {
            INodoArbol<IArticulo> nodoBuscado = aux.getObjeto().buscar(pId);
            
            if (nodoBuscado == null) {
                aux = aux.getSiguiente();
            }
            else{
                if (nodoBuscado.getDatos().getStock() > 0){
                    System.out.println("No se puede eliminar un artículo con stock");
                    return false;
                }
                else{
                    Boolean b = aux.getObjeto().eliminar(pId);
                    return b;
                    //return listaArticulos.Borrar(pId);
                }
            }
        }
        
        System.out.println("Artículo inexistente");
        return false;
    }

    @Override
    public Boolean EliminarArea(String pArea) {
        pArea = RemoverCaracteres(pArea).toUpperCase();
        INodoLista<IArbol<IArticulo>> buscado = listaArticulos.Buscar(pArea);
        
        if (buscado == null){
            System.out.println("Área inexistente");
            return false;
        }
        
        return listaArticulos.Borrar(pArea);
    }
    
    @Override
    public Boolean GuardarVenta(IMovimiento pVenta, Comparable pArea) {
        INodoArbol<IMovimiento> objNodo = new NodoArbol<IMovimiento>(pVenta.getID(), pVenta);
        INodoLista<IArbol<IMovimiento>> objNodoLista = this.listaVentas.Buscar(pArea);
        
        if (objNodoLista == null){
            IArbol<IMovimiento> objNuevoArbol = new Arbol<IMovimiento>(objNodo);
            
            objNodoLista = new NodoLista<IArbol<IMovimiento>>(objNuevoArbol, pArea);
            
            this.listaVentas.Insertar(objNodoLista);
            
            return true;
        }else{
            return objNodoLista.getObjeto().insertar(objNodo);
        }
    }

    @Override
    public Boolean ReintegroVenta(Comparable pIdVenta) {
        if (listaVentas.esVacia()) {
            return null;
       }
       else {
            INodoLista<IArbol<IMovimiento>> nodoActual = listaVentas.getPrimero();
            
            while(nodoActual != null){
                INodoArbol<IMovimiento> nodoArbol = nodoActual.getObjeto().buscar(pIdVenta);
                
                if(nodoArbol != null){
                    IMovimiento ventaBuscada = nodoArbol.getDatos();
                    
                    IArticulo objArticuloBuscado = BuscarArticuloXID(ventaBuscada.GetIdArticulo(),new String[1]);
                    
                    if (objArticuloBuscado == null){
                        return false;
                    }
                    
                    Integer stockActual = objArticuloBuscado.getStock();
                    Integer stockVendido = ventaBuscada.GetCantidad();
                    objArticuloBuscado.setStock(stockActual + stockVendido);
                    
                    nodoActual.getObjeto().eliminar(pIdVenta);
                    
                    return true;
                }
                nodoActual = nodoActual.getSiguiente();
            }
       }
        
        return false;
    }

    @Override
    public String retornarArticulos() {
        return listaArticulos.Print();
    }

    @Override
    public String retornarArticulos(String pSeparador) {
        String strRetorno = "";
        ILista<IArticulo> listaRetorno = new Lista<IArticulo>();
        
        
        if (listaArticulos.esVacia()) {
            return null;
        }
        else {
            INodoLista<IArbol<IArticulo>> nodoActual = listaArticulos.getPrimero();
            
            while(nodoActual != null){
                listaRetorno = new Lista<IArticulo>();
                nodoActual.getObjeto().buscarXAtributo("nombre", "", listaRetorno);
                strRetorno += nodoActual.getEtiqueta().toString() + "\n";
                strRetorno += listaRetorno.Print("-");
                
                nodoActual = nodoActual.getSiguiente();
            }
            
            return strRetorno;
        }
    }
    
    public ArrayList retornarArticulos(Integer pInt) {
        ArrayList ArrayRetorno = new ArrayList();
        
        if (listaArticulos.esVacia()) {
            return null;
        }
        else {
            INodoLista<IArbol<IArticulo>> nodoActual = listaArticulos.getPrimero();
            String nomArea = "";
            Integer i = 0;
             
            while(nodoActual != null){
                ILista<IArticulo> listaRetorno = new Lista<IArticulo>();
                nodoActual.getObjeto().buscarXAtributo("nombre", "", listaRetorno);
                nomArea = nodoActual.getEtiqueta().toString();
                //strRetorno += nodoActual.getEtiqueta().toString() + "\n";
                //strRetorno += listaRetorno.Print("-");
                
                if(listaRetorno != null){
                    INodoLista<IArticulo> subNodoActual = listaRetorno.getPrimero();
                    
                    while(subNodoActual != null){
                        IArticulo art = subNodoActual.getObjeto();
                        ArrayRetorno.add(i, art);
                        ArrayRetorno.add(i + 1, nomArea);
                        
                        i +=2;
                        subNodoActual = subNodoActual.getSiguiente();
                    }
                    
                }
                nodoActual = nodoActual.getSiguiente();
            }
            
            return ArrayRetorno;
        }
    }
    
    public String retornarInOrden() {
        String strRetorno = "";
        
        if (listaArticulos.esVacia()) {
            return "Lista aún no inicializado";
        }
        else {
            INodoLista<IArbol<IArticulo>> nodoActual = listaArticulos.getPrimero();
            
            while(nodoActual != null){
                
                strRetorno += nodoActual.getObjeto().inOrden();
                
                nodoActual = nodoActual.getSiguiente();
            }
            
            return strRetorno;
        }
    }
    
    @Override
    public String listarArticulosXArea(String pArea) {
        String strRetorno = "";
        
        if (listaArticulos.esVacia()) {
            return "Lista aún no inicializado";
        }
        else {
            ILista<IArticulo> listaRetorno = new Lista<IArticulo>();
            INodoLista<IArbol<IArticulo>> nodoActual = listaArticulos.getPrimero();
            
            while(nodoActual != null){
                if (nodoActual.getEtiqueta().toString().toLowerCase().equals(pArea.toLowerCase())){
                    nodoActual.getObjeto().buscarXAtributo("id", "", listaRetorno);
                    strRetorno += nodoActual.getEtiqueta().toString() + "\n";
                    strRetorno += listaRetorno.Print("-");
                }
                
                nodoActual = nodoActual.getSiguiente();
            }
            
            return strRetorno;
        }
    }
    
    public ILista<IArticulo> listarArticulosXArea(String pArea,String pp) {
        //String strRetorno = "";
        ILista<IArticulo> listaRetorno = new Lista<IArticulo>();
        
        if (listaArticulos.esVacia()) {
            return null;
        }
        else {
            
            INodoLista<IArbol<IArticulo>> nodoActual = listaArticulos.getPrimero();
            
            while(nodoActual != null){
                if (nodoActual.getEtiqueta().toString().toLowerCase().equals(pArea.toLowerCase())){
                    nodoActual.getObjeto().buscarXAtributo("id", "", listaRetorno);
//                    strRetorno += nodoActual.getEtiqueta().toString() + "\n";
//                    strRetorno += listaRetorno.Print("-");
                }
                
                nodoActual = nodoActual.getSiguiente();
            }
            
            return listaRetorno;
        }
    }
    
    @Override
    public String listarVentasXArea(String pArea) {
        String strRetorno = "";
        
        if (listaVentas.esVacia()) {
            return "";
        }
        else {
            ILista<IMovimiento> listaRetorno = new Lista<IMovimiento>();
            INodoLista<IArbol<IMovimiento>> nodoActual = listaVentas.getPrimero();
            
            while(nodoActual != null){
                if (nodoActual.getEtiqueta().toString().toLowerCase().equals(pArea.toLowerCase())){
                    nodoActual.getObjeto().buscarXAtributo("id", "", listaRetorno);
                    strRetorno += nodoActual.getEtiqueta().toString() + "\n";
                    if (listaRetorno.CantidadDeElementos() > 0){
                        strRetorno += listaRetorno.Print("-");
                    }
                }
                
                nodoActual = nodoActual.getSiguiente();
            }
            
            return strRetorno;
        }
    }
    
    @Override
    public String listarComprasXArea(String pArea) {
        String strRetorno = "";
        
        if (listaCompras.esVacia()) {
            return "";
        }
        else {
            ILista<IMovimiento> listaRetorno = new Lista<IMovimiento>();
            INodoLista<IArbol<IMovimiento>> nodoActual = listaCompras.getPrimero();
            
            while(nodoActual != null){
                if (nodoActual.getEtiqueta().toString().toLowerCase().equals(pArea.toLowerCase())){
                    nodoActual.getObjeto().buscarXAtributo("id", "", listaRetorno);
                    strRetorno += nodoActual.getEtiqueta().toString() + "\n";
                    if (listaRetorno.CantidadDeElementos() > 0){
                        strRetorno += listaRetorno.Print("-");
                    }
                }
                
                nodoActual = nodoActual.getSiguiente();
            }
            
            return strRetorno;
        }
    }
    
    public ILista<IMovimiento> listarVentasXArea(String pArea, Integer p) {
        ILista<IMovimiento> listaRetorno = new Lista<IMovimiento>();
        
        if (listaVentas.esVacia()) {
            return null;
        }
        else {
            INodoLista<IArbol<IMovimiento>> nodoActual = listaVentas.getPrimero();
            
            while(nodoActual != null){
                if (nodoActual.getEtiqueta().toString().toLowerCase().equals(pArea.toLowerCase())){
                    nodoActual.getObjeto().buscarXAtributo("id", "", listaRetorno);
                }
                
                nodoActual = nodoActual.getSiguiente();
            }
            
            return listaRetorno;
        }
    }
    
    public ILista<IMovimiento> listarComprasXArea(String pArea,Integer p) {
        ILista<IMovimiento> listaRetorno = new Lista<IMovimiento>();
        
        if (listaCompras.esVacia()) {
            return null;
        }
        else {
            INodoLista<IArbol<IMovimiento>> nodoActual = listaCompras.getPrimero();
            
            while(nodoActual != null){
                if (nodoActual.getEtiqueta().toString().toLowerCase().equals(pArea.toLowerCase())){
                    nodoActual.getObjeto().buscarXAtributo("id", "", listaRetorno);
                }
                
                nodoActual = nodoActual.getSiguiente();
            }
            
            return listaRetorno;
        }
    }
    
    @Override
    public String retornarVentas() {
        return listaVentas.Print();
    }

    @Override
    public String retornarVentas(String pSeparador) {
        if(listaVentas != null){
            return listaVentas.Print(pSeparador);
        }
        
        return "Lista aún no inicializado";
    }
    
    public ILista<IMovimiento> retornarVentas(Integer pInt) {
        ILista<IMovimiento> listaRetorno = new Lista<IMovimiento>();
        
        if (listaArticulos.esVacia()) {
            return null;
        }
        else {
            INodoLista<IArbol<IMovimiento>> nodoActual = listaVentas.getPrimero();
            String nomArea = "";
            Integer i = 0;
             
            while(nodoActual != null){
                listaRetorno = new Lista<IMovimiento>();
                nodoActual.getObjeto().buscarXAtributo("id", "", listaRetorno);
                
                nodoActual = nodoActual.getSiguiente();
            }
            
            return listaRetorno;
        }
    }
    
    
    @Override
    public Double promedioVentasXArticulo(Integer pIdArticulo){
        ILista<IMovimiento> listaVentas = buscarVentasXProducto(pIdArticulo);
        Double promedioTotal = 0D;
        Long fechaMaxima = 0L;
        Long fechaMinima = 0L;
        
        if (listaVentas == null || listaVentas.CantidadDeElementos() == 0){
            promedioTotal = 0D;
        }else{
            INodoLista<IMovimiento> nodoActual = listaVentas.getPrimero();
            fechaMinima = nodoActual.getObjeto().GetFecha().getTime();
            
            while(nodoActual != null){
                Long fechaVenta = nodoActual.getObjeto().GetFecha().getTime();
                if (fechaVenta < fechaMinima){
                    fechaMinima = fechaVenta;
                }
                
                if (fechaVenta > fechaMaxima){
                    fechaMaxima = fechaVenta;
                }
                
                promedioTotal += nodoActual.getObjeto().GetCantidad();
                
                nodoActual = nodoActual.getSiguiente();
            }
            
            Date dateFechaMinima = new Date(fechaMinima);
            Date dateFechaMaxima = new Date(fechaMaxima);
            
            Calendar startCalendar = new GregorianCalendar();
            startCalendar.setTime(dateFechaMinima);
            Calendar endCalendar = new GregorianCalendar();
            endCalendar.setTime(dateFechaMaxima);

            int diffYear = endCalendar.get(Calendar.YEAR) - startCalendar.get(Calendar.YEAR);
            int diffMonth = (diffYear * 12 + endCalendar.get(Calendar.MONTH) - startCalendar.get(Calendar.MONTH)) + 1;
            
            promedioTotal = promedioTotal / diffMonth;
        }
        
        return promedioTotal;
    }
    
    @Override
    public ILista<IMovimiento> buscarVentasXProducto(Integer pIDProducto){
        ILista<IMovimiento> listaRetorno = new Lista<IMovimiento>();
        if (listaVentas.esVacia()) {
            listaRetorno = null;
       }
       else {
            INodoLista<IArbol<IMovimiento>> nodoActual = listaVentas.getPrimero();
            
            while(nodoActual != null){
                nodoActual.getObjeto().buscarXAtributo("idArticulo", pIDProducto.toString(),listaRetorno);
                
                nodoActual = nodoActual.getSiguiente();
            }
       }
        
        return listaRetorno;
    }
    
    @Override
    public ILista<IMovimiento> ListadoVenta(Long pFechaComienzo, Long pFechaFin) {
        ILista<IMovimiento> listaRetorno = new Lista<IMovimiento>();
        
        if (listaVentas.esVacia()) {
            return null;
       }
       else {
            INodoLista<IArbol<IMovimiento>> nodoActual = listaVentas.getPrimero();
            String str = "";
            while(nodoActual != null){
                nodoActual.getObjeto().buscarInRango(pFechaComienzo,pFechaFin,listaRetorno);
                
                nodoActual = nodoActual.getSiguiente();
            }
            
            return listaRetorno;
       }
    }
    
    /**
        * Método auxiliar que, dada una string con formato de fecha, la convierte
        * en un dato de tipo Date.
        * @param pFecha Fecha a castear.
        * @return Fecha en formato Date.
    **/
    public Date FormatoFecha (String pFecha) throws ParseException{
           try {
               SimpleDateFormat dt = new SimpleDateFormat("yyyy-MM-dd hh:mm:ss");
               Date date = dt.parse(pFecha);
               return date;
           } catch (ParseException e)
               {
                   throw e;
                   //System.err.println("Error de parsing: " + e.getMessage());
               }
       }

       /**
        * Metodo auxiliar que dada una string verifica que sea "Activo" o "Inactivo"
        * y le asigna valores booleanos correspondientes,
        * donde activo = true e inactivo = false.
        * @param str String a verificar.
        * @return Valor booleano correspondiente.
        */
       private Boolean VerificarEstado(String value) throws Exception{
           value = value.trim();
           try {
               if (value.toUpperCase().equals("ACTIVO")){
                   return true; 
               }
               else if (value.toLowerCase().equals("inactivo")){
                   return false;
               }
               else if (value.equals("")){
                   return null;
               }
               else {
                   throw new Exception("El valor " + value + " no es valido. Debe ser Activo/Inactivo.");
               }
           } catch (Exception ex) {
               throw ex;
               //System.out.println(ex.getMessage());
           }
       }

       /**
        * Metodo auxiliar que verifica si una string es "true" or "false",
        * y le asigna valores booleanos en consecuencia.
        * @param str String a verificar.
        * @return Valor booleano correspondiente.
        */
       private Boolean VerificarBooleano(String value) throws Exception{
           try {
               if ("True".equals(value) || "true".equals(value)){
                   return true;
               }
               if ("False".equals(value) || "false".equals(value)){
                   return false;
               }
               else {
                   throw new Exception("El valor " + value + " no es valido");
               }
           }
           catch (Exception ex){
               throw ex;
               //System.out.println(ex.getMessage());
           }
       }
           
       private String RemoverCaracteres(String pCadena) {
            String caracteresRaros = "áàäéèëíìïóòöúùuñÁÀÄÉÈËÍÌÏÓÒÖÚÙÜÑçÇ";
            String caracteresOriginales = "aaaeeeiiiooouuunAAAEEEIIIOOOUUUNcC";
            
            String strRetorno = pCadena;
            for (int i=0; i< caracteresRaros.length(); i++) {
                // Reemplazamos los caracteres especiales.
                strRetorno = strRetorno.replace(caracteresRaros.charAt(i), caracteresOriginales.charAt(i));
            }
            return strRetorno;
        }
    //</editor-fold>

    @Override
    public Lista<IArbol<IMovimiento>> getCompras() {
        throw new UnsupportedOperationException("Not supported yet."); //To change body of generated methods, choose Tools | Templates.
    }
 
}
