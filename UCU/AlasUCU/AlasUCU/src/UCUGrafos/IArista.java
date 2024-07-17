package UCUGrafos;

import Clases.*;
import java.util.LinkedList;

/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

/**
 * 
 * @author Lithium582
 */
public interface IArista {

    /**
     * Retorna las relaciones vinculadas a la Arista
     * @return Lista enlazada de vuelos
     */
    LinkedList<IVuelo> getRelaciones();

    /**
     * Retorna un comparable representando al aeropuerto destino
     * @return Comparable con el código del aeropuerto destino
     */
    Comparable getEtiquetaDestino();

    /**
     * Retorna un comparable representando al aeropuerto origen
     * @return Comparable con el código del aeropuerto origen
     */
    Comparable getEtiquetaOrigen();
    
    /**
     * Ingresa un nuevo código de aeropuerto destino
     * @param etiquetaDestino Nuevo aeropuerto destino
     */
    void setEtiquetaDestino(Comparable etiquetaDestino);

    /**
     * Ingresa un nuevo código de aeropuerto de origen
     * @param etiquetaOrigen Nuevo aeropuerto origen
     */
    void setEtiquetaOrigen(Comparable etiquetaOrigen);

    /**
     * Ingresa los vuelos que conectan los aeropuertos origen y destino
     * @param pRelaciones Lista de vuelos
     */
    void setRelaciones(LinkedList<IVuelo> pRelaciones);
}
