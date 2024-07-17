/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package Interfaces;

import Clases.*;
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
    public Lista<IArbol<IArticulo>> getArticulos();

    /**
     * Retorna la lista de ventas
     * @return Retorna la lista.
     */
    public Lista<IArbol<IMovimiento>> getVentas();
    
    /**
     * Retorna la lista de compras
     * @return Retorna la lista.
     */
    public Lista<IArbol<IMovimiento>> getCompras();
    
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
     * @param pAreaProducto Array donde se cargará el nombre del área a la que pertenece el producto buscado
     * @return Artículo encontrado.
     */
    public IArticulo BuscarArticuloXID(Comparable id, String[] pAreaProducto);

    /**
     * Busca un Artículo por su descripción.
     *
     * @param pDescripcion Descripción del Artículo.
     * @return Artículo encontrado.
     */
    public String buscarXDescripcion(String pDescripcion);
    
    /**
     * Retorna la cantidad de artículos en STOCK
     *
     * @return Cantidad de Artículos en stock
     */
    public Integer CantidadDeArticulos();
    
    /**
     * Busca a todos los artículos cuya descripción coincida con el parámetro recibido.
     *
     * @param pDescripcion Descripción del Artículo.
     * @return Artículo encontrado.
     */
    public ILista<IArticulo> listarXDescripcion(String pDescripcion);
    
    /**
     * Busca a todos los artículos cuyo nombre coincida con el parámetro recibido.
     *
     * @param pNombre Nombre del Artículo.
     * @return Artículo encontrado.
     */
    public ILista<IArticulo> listarXNombre(String pNombre);
    
    /**
     * Busca un Artículo por su nombre.
     *
     * @param pNombre Nombre del Artículo.
     * @return Artículo encontrado.
     */
    public String buscarXNombre(String pNombre);

    /**
     * Lista todos los artículos por su año de vencimiento
     *
     * @param pAnoVencimiento Año de vencimiento de los artículos que se buscan
     * @return Artículos encontrado.
     */
    public ILista<IArticulo> buscarArticulosXAnoVencimiento(String pAnoVencimiento);
    
    /**
     * Agregar un nuevo Artículo a la lista
     * De ya existir, agrega uno a la cantidad existente en stock
     *
     * @param pArticulo Nuevo Artículo
     * @param pArea Área a la que pertenece el artículo
     * @return Artículo insertado con éxito
    **/
    public Boolean InsertarArticulo(IArticulo pArticulo, Comparable pArea);

    /**
     * Elimina un artículo de la lista
     *
     * @param pId ID del artículo a eliminar
     * @return Eliminación realizada con éxito.
     */
    public Boolean EliminarArticulo(Comparable pId);

    /**
     * Elimina un artículo de la lista
     *
     * @param pArea Área a eliminar
     * @return Eliminación realizada con éxito.
     */
    public Boolean EliminarArea(String pArea);
    
    /**
     * Guarda la venta recibida por parámetro en la lista
     * y modifica la lista de artículos en consecuencia del
     * artículo vendido.
     *
     * @param pVenta Venta realizada
     * @param pArea Área a la que pertenece la venta
     * @return Venta realizada con éxito
     */
    public Boolean GuardarVenta(IMovimiento pVenta, Comparable pArea);

    /**
     * Agrega stock a un producto existente.
     *
     * @param pIdVenta ID de la venta reintegrada
     * @return Booleano indicando si la operacion fue realizada correctamente.
     */
    public Boolean ReintegroVenta(Comparable pIdVenta);
    
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
     * Retorna el promedio general de ventas
     * 
     * @param pIdArticulo ID del artículo cuyo promedio de ventas se busca
     * @return String conteniendo los items de la lista.
     */
    public Double promedioVentasXArticulo(Integer pIdArticulo);
    
    /**
     * Retorna los artículos pertenecientes a un área determinada
     * 
     * @param pArea Área buscada
     * @return String conteniendo los items de la lista.
     */
    public String listarArticulosXArea(String pArea);
    
    /**
     * Retorna las ventas pertenecientes a un área determinada
     * 
     * @param pArea Área buscada
     * @return String conteniendo los items de la lista.
     */
    public String listarVentasXArea(String pArea);
    
    /**
     * Retorna las compras pertenecientes a un área determinada
     * 
     * @param pArea Área buscada
     * @return String conteniendo los items de la lista.
     */
    public String listarComprasXArea(String pArea);
    
    /**
     * Retorna las ventas de un artículo determinado
     * 
     * @param pIDProducto ID del producto cuyas ventas se quieren listar
     * @return String conteniendo los items de la lista.
     */
    public ILista<IMovimiento> buscarVentasXProducto(Integer pIDProducto);
    
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
    public ILista<IMovimiento> ListadoVenta(Long pFechaComienzo, Long pFechaFin);
    
    /**
     * Mediante la carga de un archivo con extensión .csv,
     * carga el stock de productos
     * @param rutaArchivo Ruta del archivo.
     * @return Retorna si la carga fue exitosa
     */
    public Boolean cargarStock(String rutaArchivo);
}
