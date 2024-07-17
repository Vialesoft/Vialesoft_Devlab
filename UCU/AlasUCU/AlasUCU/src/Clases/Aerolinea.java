/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package Clases;

/**
 * Aeolínea beía tá bolano!
 * @author Lithium582
 */
public class Aerolinea {
    private final Comparable<String> ID;
    private String nombre;

    /**
     * Devuelve el identificador de la aerolínea
     * @return ID del aeropuerto.
     */
    public Comparable<String> getID(){
        return this.ID;
    }
    
    /**
     * Devuelve el nombre de la aerolínea.
     * @return Nombre
     */
    public String getNombre() {
        return this.nombre;
    }
    
    /**
     * Devuelve el nombre de la aerolínea.
     * @param pNombre Nombre nuevo del Aerolínea
     */
    public void setNombre(String pNombre) {
        this.nombre = pNombre;
    }
    
    /**
     * Constructor de la aerolínea.
     * @param pID Identificador de la aerolínea
     * @param pNombre Nombre
     */
    public Aerolinea(Comparable<String> pID, String pNombre) {
        this.ID = pID;
        this.nombre = pNombre;
    }
    
    @Override
    public String toString(){
        return "Aerolínea " + this.ID + " - " + this.nombre;
    }
}