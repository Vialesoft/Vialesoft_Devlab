/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package Clases;
import Interfaces.*;
import java.util.LinkedList;

/**
 *
 * @param <T> Tipo del árbol
 * @author Lithium582
 */
public class Arbol<T> implements IArbol<T> {

    // <editor-fold defaultstate="extended" desc="Atributos">
    private INodoArbol<T> raiz;
    // </editor-fold>

    // <editor-fold defaultstate="extended" desc="Constructor">
    public Arbol() {
        raiz = null;
    }
    
    public Arbol(INodoArbol pNodo){
        raiz = pNodo;
    }
    // </editor-fold>
    
    // <editor-fold defaultstate="extended" desc="Propiedad">
    public INodoArbol<T> getRaiz() {
        return this.raiz;
    }
    // </editor-fold>

    // <editor-fold defaultstate="extended" desc="Atributos">
    @Override
    public boolean insertar(INodoArbol<T> pNodo) {
        if (esVacio()) {
            raiz = pNodo;
            return true;
        } else {
            return raiz.insertar(pNodo);
        }
    }

    @Override
    public INodoArbol<T> buscar(Comparable pEtiqueta) {
        if (esVacio()) {
            return null;
        } else {
            return raiz.buscar(pEtiqueta);
        }
    }
    
    @Override
    public void buscarInRango(Comparable pValorMinimo, Comparable pValorMaximo, ILista<T> pListaRetorno){
        if (!esVacio()){
            raiz.buscarInRango(pValorMinimo, pValorMaximo,pListaRetorno);
        }
    }
    
    @Override
    public void buscarXAtributo(String aParam, String pValorParametro, ILista<T> pListaRetorno){
        if(esVacio()){
            pListaRetorno = null;
        }else{
            raiz.buscarXAtributo(aParam, pValorParametro, pListaRetorno);
        }
    }
    
    @Override
    public String buscarXAtributo(String pAttr, String pStringBuscado){
        if (esVacio()){
            return "";
        }else{
            return raiz.buscarXAtributo(pAttr, pStringBuscado);
        }
    }

    @Override
    public String inOrden() {
        if (esVacio()) {
            return null;
        } else {
            return raiz.inOrden();
        }
    }
     
    @Override
    public boolean esVacio() {
        return (raiz == null);
    }

    @Override
    public boolean vaciar() {
        if (!esVacio()) {
            raiz = null;
            return true;
        }
        return false;
    }

    @Override
    public Boolean eliminar(Comparable pEtiqueta) {
        if (!esVacio()) {
            this.raiz = this.raiz.eliminar(pEtiqueta);
            return true;
        }
        
        return false;
    }
    
    @Override
    public INodoArbol lexicoGraficamenteAnterior(Comparable pClave){
        if (raiz != null) {
            return raiz.lexicoGraficamenteAnterior(pClave);
        } else {
            return null;
        }
    }

    @Override
    public String posOrden() {
        if (esVacio()) {
            return null;
        } else {
            return raiz.posOrden();
        }
    }

    @Override
    public String preOrden() {
        if (esVacio()) {
            return null;
        } else {
            return raiz.preOrden();
        }
    }

    @Override
    public int getAltura() {
        if (esVacio()) {
            return -1;
        } else {
            return raiz.getAltura();
        }
    }

    @Override
    public int getTamano() {
        if (esVacio()) {
            return -1;
        } else {
            return raiz.getTamano();
        }
    }

    @Override
    public int getNivel(Comparable pEtiqueta) {
        if (esVacio()) {
            return -1;
        } else {
            return raiz.getNivel(pEtiqueta);
        }
    }

    @Override
    public int getHojas() {
        if (esVacio()) {
            return -1;
        } else {
            return raiz.getHojas();
        }
    }
    
    @Override
    public String toString(){
        if (esVacio()) {
            return null;
        } else {
            return raiz.printInOrden();
        }
    }
    
    // </editor-fold>
}
