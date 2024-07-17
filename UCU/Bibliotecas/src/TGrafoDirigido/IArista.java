package TGrafoDirigido;


/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

/**
 *
 * @author Ernesto
 */
public interface IArista {

    /**
     *
     * @return
     */
    double getCosto();

    /**
     *
     * @return
     */
    Comparable getEtiquetaDestino();

    /**
     *
     * @return
     */
    Comparable getEtiquetaOrigen();

    /**
     *
     * @param costo
     */
    void setCosto(double costo);

    /**
     *
     * @param etiquetaDestino
     */
    void setEtiquetaDestino(Comparable etiquetaDestino);

    /**
     *
     * @param etiquetaOrigen
     */
    void setEtiquetaOrigen(Comparable etiquetaOrigen);
    
}
