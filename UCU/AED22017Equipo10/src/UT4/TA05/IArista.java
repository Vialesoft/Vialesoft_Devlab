package UT4.TA05;

import UT4.TA04.*;

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

    double getCosto();

    Comparable getEtiquetaDestino();

    Comparable getEtiquetaOrigen();

    void setCosto(double costo);

    void setEtiquetaDestino(Comparable etiquetaDestino);

    void setEtiquetaOrigen(Comparable etiquetaOrigen);
    
}
