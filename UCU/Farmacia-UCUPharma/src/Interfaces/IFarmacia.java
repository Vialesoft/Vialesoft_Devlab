/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package Interfaces;

import java.util.Date;
import Clases.Lista;
/**
 *
 * @author Lithium582
 */
public interface IFarmacia {

    /**
     * Retorna la dirección de la farmacia
     * @return Dirección
     */
    public String getDireccion();

    /**
     * Carga la dirección de la Farmacia
     * @param value Dirección nueva.
     */
    public void setDireccion(String value);

    /**
     * Obtiene el teléfono de la Farmacia.
     * @return Teléfono.
    **/
    public String getTelefono();

    /**
     * Obtiene el teléfono de la Farmacia
     * @param value Teléfono nuevo
    **/
    public void setTelefono(String value);

    /**
     * Retorna el nombre de la sucursal
     * @return Nombre de la sucursal
     */
    public String getNombre();

    /**
     * Retorna la lista de artículos
     * @return Retorna la lista.
     */
    public Lista<IArticulo> getArticulos();

    /**
     * Retorna la lista de ventas
     * @return Retorna la lista.
     */
    public Lista<IVenta> getVentas();
    
    /**
     * Mediante la carga de un archivo con extensión .csv,
     * carga la lista de Productos en la clase
     * @param rutaArchivo Ruta del archivo.
     * @return Retorna si la carga fue exitosa
     */
    public Boolean cargarArticulos(String rutaArchivo);
    
    /**
     * Dado un ID de Artículo, nos indica si existe en el Stock.
     *
     * @param id ID del Artículo a buscar.
     * @return Artículo encontrado.
     */
    public IArticulo BuscarXID(Integer id);

    /**
     * Busca un Artículo por su descripción.
     *
     * @param pDescripcion Descripción del Artículo.
     * @return Artículo encontrado.
     */
    public String buscarXDescripcion(String pDescripcion);
    
    /**
     * Busca un Artículo por su nombre.
     *
     * @param pNombre Nombre del Artículo.
     * @return Artículo encontrado.
     */
    public String buscarXNombre(String pNombre);

    /**
     * Agregar un nuevo Artículo a la lista
     * De ya existir, agrega uno a la cantidad existente en stock
     *
     * @param pArticulo Nuevo Artículo
     * @return Artículo insertado con éxito
    **/
    public Boolean InsertarArticulo(IArticulo pArticulo);

    /**
     * Elimina un artículo de la lista
     *
     * @param pId ID del artículo a eliminar
     * @return Eliminación realizada con éxito.
     */
    public Boolean EliminarArticulo(Integer pId);

    /**
     * Guarda la venta recibida por parámetro en la lista
     * y modifica la lista de artículos en consecuencia del
     * artículo vendido.
     *
     * @param pVenta Venta realizada
     * @return Venta realizada con éxito
     */
    public Boolean GuardarVenta(IVenta pVenta);

    /**
     * Agrega stock a un producto existente.
     *
     * @param pIdVenta ID de la venta reintegrada
     * @return Booleano indicando si la operacion fue realizada correctamente.
     */
    public Boolean ReintegroVenta(Integer pIdVenta);
    
    /*
        Recibe ID venta y elimina esa venta retornándola de la lista
        (Agregar metodo que busque y elimine de la lista)
        Después busca el artículo en la lista de artículos y le cambia el stock
    */
    
    //--------------------------------------------------------------

    
    /**
     * Imprime la lista de productos.
     * @return String conteniendo los items de la lista.
     */
    public String retornarArticulos();

    /**
     * Dado un separador, imprime los productos separados por tal caracter.
     *
     * @param pSeparador Separador a utilizar.
     * @return Productos separados.
     */
    public String retornarArticulos(String pSeparador);
    
    /**
     * Imprime la lista de ventas.
     * @return String conteniendo los items de la lista.
     */
    public String retornarVentas();

    /**
     * Dado un separador, imprime las ventas separadas por el caracter pasado por parámetro.
     *
     * @param pSeparador Separador a utilizar.
     * @return String conteniendo los items de la lista.
     */
    public String retornarVentas(String pSeparador);

    /*
        Llama al ToString de los artículos
    */
    
    /**
     * Devuelve una lista con todos los productos vendidos entre
     * dos fechas determinadas.
     * Ademas, imprime en pantalla sus datos.
     * @param pFechaComienzo Primera fecha
     * @param pFechaFin Segunda fecha
     * @return Lista conteniendo todos los productos vendido entre
     * esas dos fechas
     */
    public String ListadoVenta(Date pFechaComienzo, Date pFechaFin);
    
    /**
     * Mediante la carga de un archivo con extensión .csv,
     * carga el stock de productos
     * @param rutaArchivo Ruta del archivo.
     * @return Retorna si la carga fue exitosa
     */
    public Boolean cargarStock(String rutaArchivo);
}
