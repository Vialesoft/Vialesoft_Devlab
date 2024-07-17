/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package Clases;
import Interfaces.*;
import java.util.Objects;

/**
 *
 * @author Lithium582
 */
public class Nodo<T extends IColeccionable> implements INodo<T> {
    private Integer etiqueta;
    private T objeto;
    private Nodo<T> siguiente;
    
    public Nodo(T objeto, Integer etiqueta) {
        this.objeto = objeto;
        this.etiqueta = etiqueta;
    }
    
    @Override
    public T getObjeto() {
        return this.objeto;
    }

    @Override
    public void setObjeto(T pValue) {
        this.objeto = pValue;
    }

    @Override
    public void setSiguiente(INodo<T> pValue) {
        this.siguiente = (Nodo<T>)pValue;
    }

    @Override
    public INodo<T> getSiguiente() {
        return this.siguiente;
    }

    @Override
    public void print() {
        System.out.println(objeto.toString());
    }

    @Override
    public void PrintEtiqueta() {
        System.out.println(etiqueta);
    }

    @Override
    public boolean equals(INodo<T> pNodo) {
        return Objects.equals(this.etiqueta, pNodo.getEtiqueta());
    }

    @Override
    public Integer getEtiqueta() {
        return this.etiqueta;
    }

    @Override
    public Comparable compareTo(Integer etiqueta) {
        return this.getEtiqueta().compareTo(etiqueta);
    }
    
}
