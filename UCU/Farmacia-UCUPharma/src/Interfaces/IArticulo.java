/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package Interfaces;

import Interfaces.*;
import java.util.Date;
/**
 *
 * @author Lithium582
 */
public interface IArticulo extends IColeccionable {
    /**
     * Devuelve la Fecha de Creación del Articulo
     * @return
     */
    public Date getFechaCreacion();

    /**
     * Carga un valor a la fecha de creación del Articulo
     * @param value Valor
     */
    public void setFechaCreacion(Date value);
    
    /**
     * Devuelve la Fecha de Actualización del Articulo
     * @return
     */
    public Date getFechaActualizacion();

    /**
     * Carga un valor a la fecha de actualización del Articulo
     * @param value Valor
     */
    public void setFechaActualizacion(Date value);
    
    /**
     * Retorna el precio del Articulo
     * @return
     */
    public double getPrecio();

    /**
     * Carga un valor al precio del Articulo
     * @param value Valor
     */
    public void setPrecio(double value);
    
    /**
     * Retorna el nombre del Articulo
     * @return
     */
    public String getNombre();

    /**
     * Carga un valor al nombre del Articulo
     * @param value Valor
     */
    public void setNombre(String value);
    
    /**
     * Retorna la descripción del Articulo
     * @return
     */
    public String getDescripcion();

    /**
     * Carga un valor a la descripción del Articulo
     * @param value Valor
     */
    public void setDescripcion(String value);
    
    /**
     * Retorna el estado del Articulo
     * @return
     */
    public Boolean getEstado();

    /**
     * Carga un valor al estado del Articulo
     * @param value Valor
     */
    public void setEstado(Boolean value);
    
    /**
     * Retorna la necesidad de refrigeración del Articulo
     * @return
     */
    public boolean getRefrigerado();

    /**
     * Carga un valor a la necesidad de refrigeración del Articulo
     * @param value Valor
     */
    public void setRefrigerado(boolean value);
    
    /**
     * Retorna la necesidad de receta del Articulo
     * @return
     */
    public boolean getReceta();

    /**
     * Carga un valor a la necesidad de receta del Articulo
     * @param value Valor
     */
    public void setReceta(boolean value);
    
    /**
     * Retorna el stock del Articulo.
     * @return Cantidad de items.
     */
    public int getStock();
    
    /**
     * Carga un nuevo valor al stock del Articulo.
     * @param value Valor.
     */
    public void setStock(Integer value);
}
