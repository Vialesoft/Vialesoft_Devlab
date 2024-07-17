/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package Interfaces;

/**
 *
 * @author Lithium582
 */
public interface IColeccionable {
    /**
     * Obtiene la ID del Elemento
     * @return
     */
    public Integer getID();
    
    /**
     * Obtiene la información más relevante del objeto
     * @return
     */
    public String toString(String pSeparador);

}
