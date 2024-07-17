/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package Clases;

import java.util.Date;
/**
 *
 * @author Lithium582
 */
public interface IVuelo {
    /**
     * Nos devuelve el identificador del vuelo en cuestion.
     * @return ID de vuelo.
     */
    public Comparable<Integer> getID();

    /**
     * Nos devuelve la ciudad de origen de dicho vuelo.
     * @return Origen.
     */
    public Comparable<String> getOrigen();
    
    /**
     * Nos devuelve el destino del vuelo.
     * @return Destino.
     */
    public Comparable<String> getDestino();
    
    /**
     * Nos devuelve el costo del viaje.
     * @return Costo.
     */
    public double getCosto();
    
    /**
     * Nos permite asignarle un nuevo costo al viaje.
     * @param pCosto Nuevo costo.
     */
    public void setCosto(float pCosto);
    
    /**
     * Retorna la aerolínea encargada del vuelo
     * @return Aerolínea
     */
    public Comparable<String> getAerolinea();
    
    /**
     * Nos permite asignarle una nueva aerolínea al viaje
     * @param pAerolinea ID de la nueva Aerolínea
     */
    public void setAerolinea(Comparable<String> pAerolinea);
    
}
