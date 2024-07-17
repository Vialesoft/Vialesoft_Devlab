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
public interface IMovimiento{
        
    /**
     * Devuelve el ID de la venta
     * @return
     */
    public Comparable getID();
    
    /**
     * Devuelve la Fecha de Realizada la venta
     * @return
     */
    public Date GetFecha();
    
    /**
     * Devuelve la el ID del Artículo vendido
     * @return
     */
    public Comparable GetIdArticulo();
    
    /**
     * Establece la ID del artículo vendido
     * @param value ID del artículo vendido
     */
    public void SetIdArticulo(Comparable value);
    
    /**
     * Devuelve la cantidad del artículo vendido
     * @return
     */
    public Integer GetCantidad();
    
    /**
     * Establece la cantidad del artículo vendido
     * @param value Cantidad
     */
    public void SetCantidad(Integer value);
    
    /**
     * Devuelve el valor final de la venta
     * @return
     */
    public Double GetValorFinal();
    
}
