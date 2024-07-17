/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package Clases;

/**
 *
 * @author Lithium582
 */
public class Aeropuerto {
    private final Comparable<String> ID;
    private String nombre;
    private final String ciudad;
    private final String pais;

    /**
     * Nos devuelve el identificador del aeropuerto.
     * @return ID del aeropuerto.
     */
    public Comparable<String> getID(){
        return this.ID;
    }
    
    /**
     * Nos devuelve el nombre del aeropuerto.
     * @return Nombre
     */
    public String getNombre() {
        return this.nombre;
    }
    
    /**
     * Nos devuelve el nombre del aeropuerto.
     * @param pNombre Nombre nuevo del Aeropuerto
     */
    public void setNombre(String pNombre) {
        this.nombre = pNombre;
    }

    /**
     * Nos devuelve la ciudad del aeropuerto.
     * @return Ciudad
     */
    public String getCiudad() {
        return this.ciudad;
    }
    
    /**
     * Nos devuelve el pais donde se encuentra el aeropuerto
     * @return Pais
     */
    public String getPais() {
        return this.pais;
    }

    /**
     * Constructor del aeropuerto.
     * @param pID Identificador del aeopuerto
     * @param pNombre Nombre
     */
    public Aeropuerto(Comparable<String> pID, String pNombre) {
        this.ID = pID;
        this.nombre = pNombre;
        this.ciudad = "Javaland";
        this.pais = "Hawaii";
    }
    
    /**
     * Retorna una cadena con los datos del aeropuerto
     * @return Información del Aeropuerto
     */
    public String imprimir(){
        return "Aeropuerto " + this.ID + " - " + this.nombre;
    }
    
    @Override
    public String toString(){
        return this.nombre;
    }
}