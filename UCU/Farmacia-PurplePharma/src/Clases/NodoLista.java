/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package Clases;
import Interfaces.*;
import java.util.Objects;

/**
 * @param <T> tipo del nodo
 * @author Lithium582
 */
public class NodoLista<T> implements INodoLista<T> {
    
    // <editor-fold defaultstate="extended" desc="Atributos">
    private Comparable etiqueta;
    private T objeto;
    private NodoLista<T> siguiente;
    // </editor-fold>
    
    public NodoLista(T objeto, Comparable etiqueta) {
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
    public void setSiguiente(INodoLista<T> pValue) {
        this.siguiente = (NodoLista<T>)pValue;
    }

    @Override
    public INodoLista<T> getSiguiente() {
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
    public boolean equals(INodoLista<T> pNodo) {
        return Objects.equals(this.etiqueta, pNodo.getEtiqueta());
    }

    @Override
    public Comparable getEtiqueta() {
        return this.etiqueta;
    }

    @Override
    public Comparable compareTo(Comparable etiqueta) {
        return this.getEtiqueta().compareTo(etiqueta);
    }
    
}
