/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package Clases;

import Interfaces.*;
import java.lang.reflect.Field;

/**
 *
 * @param <T> Tipo del nodo
 * @author Lithium582
 */

public class NodoArbol<T> implements INodoArbol<T> {

    // <editor-fold defaultstate="extended" desc="Atributos">
    private final Comparable etiqueta;
    private INodoArbol hijoIzq;
    private INodoArbol hijoDer;
    private final T datos;
    // </editor-fold>

    // <editor-fold defaultstate="extended" desc="Propiedades">
    @Override
    public INodoArbol getHijoIzq() {
        return hijoIzq;
    }

    @Override
    public INodoArbol getHijoDer() {
        return hijoDer;
    }
    
    @Override
    public Comparable getEtiqueta() {
        return etiqueta;
    }
    
        @Override
    public T getDatos() {
        return datos;
    }

    @Override
    public void setHijoIzq(INodoArbol<T> elemento) {
        this.hijoIzq = elemento;
    }

    @Override
    public void setHijoDer(INodoArbol elemento) {
        this.hijoDer = elemento;
    }
    
    // </editor-fold>
    
    // <editor-fold defaultstate="extended" desc="Constructor">
    /**
     * @param unaEtiqueta
     * @param unosDatos
     */
    public NodoArbol(Comparable unaEtiqueta, T unosDatos) {
        etiqueta = unaEtiqueta;
        datos = unosDatos;
    }
    // </editor-fold>

    // <editor-fold defaultstate="extended" desc="Métodos y Funciones">
    /**
     * @param unElemento
     * @return
     */
    @Override
    public boolean insertar(INodoArbol unElemento) {
        if (unElemento.getEtiqueta().compareTo(this.etiqueta) < 0) {
            if (this.hijoIzq != null) {
                return this.hijoIzq.insertar(unElemento);
            } else {
                this.hijoIzq = unElemento;
                return true;
            }
        } else if (unElemento.getEtiqueta().compareTo(this.etiqueta) > 0) {
            if (this.hijoDer != null) {
                return this.hijoDer.insertar(unElemento);
            } else {
                this.hijoDer = unElemento;
                return true;
            }
        } else {
            // Ya existe un elemento con esa etiqueta
            return false;
        }
    }

    /**
     * @param unaEtiqueta
     * @return
     */
    @Override
    public INodoArbol buscar(Comparable unaEtiqueta) {

        if (unaEtiqueta.equals(etiqueta)) {
            return this;
        } else if (unaEtiqueta.compareTo(etiqueta) < 0) {
            if (hijoIzq != null) {
                return getHijoIzq().buscar(unaEtiqueta);
            } else {
                return null;
            }
        } else if (hijoDer != null) {
            return getHijoDer().buscar(unaEtiqueta);
        } else {
            return null;
        }
    }
    
    @Override
    public String buscarXAtributo(String pStringBuscado, String pAttr){
        try{
            String strReturn = "";
            Class c = this.datos.getClass();
            Field f;
            
            try{
                f = c.getDeclaredField(pAttr);
            }
            catch(Exception ex){
                return "";
            }
            
            f.setAccessible(true);
            String val = f.get(this.datos).toString();

            if (val.toLowerCase().contains(pStringBuscado.toLowerCase())) {
                strReturn += this.datos.toString();
            }
            
            if (hijoIzq != null) {
                strReturn += getHijoIzq().buscarXAtributo(pAttr, pStringBuscado);
            }
            
            if (hijoDer != null) {
                strReturn += getHijoDer().buscarXAtributo(pAttr, pStringBuscado);
            } 
            
            return strReturn;
        }catch(Exception ex){
            return "";
        }
    }
    
    @Override
    public void buscarXAtributo(String aParam, String pValorParametro, ILista<T> pListaRetorno){
        try {
            if (pListaRetorno == null){
                pListaRetorno = new Lista<T>();
            }
            Class c = this.datos.getClass();
            Field f;
            
            try{
                f = c.getDeclaredField(aParam);
            }
            catch(Exception ex){
                return;
            }
            
            f.setAccessible(true);

            String val = f.get(this.datos).toString();

            if (val.toLowerCase().contains(pValorParametro.toLowerCase())) {
                pListaRetorno.Insertar(new NodoLista(this.datos,val));
            }

            if (this.hijoIzq != null) {
                this.hijoIzq.buscarXAtributo(aParam, pValorParametro, pListaRetorno);
            }

            if (this.hijoDer != null) {
                this.hijoDer.buscarXAtributo(aParam, pValorParametro, pListaRetorno);
            }
        }
        catch(Exception ex){
            System.out.println(ex.getMessage());
        }
    }

    @Override
    public void buscarInRango(Comparable pValorMinimo, Comparable pValorMaximo, ILista<T> pListaRetorno){
        if (pListaRetorno == null){
            pListaRetorno = new Lista<T>();
        }
        
        Boolean a = this.etiqueta.compareTo(pValorMaximo) < 0;
        Boolean b = this.etiqueta.compareTo(pValorMinimo) > 0;
        Boolean c = this.etiqueta.compareTo(pValorMinimo) == 0;
        Boolean d = this.etiqueta.compareTo(pValorMaximo) == 0;
        
        if((a && b) || (c || d)){
            NodoLista<T> objNuevoNodo = new NodoLista<T>(this.datos,this.etiqueta);
            pListaRetorno.Insertar(objNuevoNodo);
        }
        
        if(b){
            if(this.hijoIzq != null){
                hijoIzq.buscarInRango(pValorMinimo, pValorMaximo, pListaRetorno);
            }
        }
            
        if(a){
            if(this.hijoDer != null){
            hijoDer.buscarInRango(pValorMinimo, pValorMaximo, pListaRetorno);
            }
        }
        
    }
    
    /**
     * @return recorrida en inorden del subArbol que cuelga del elemento actual
     */
    @Override
    public String inOrden() {
        StringBuilder tempStr = new StringBuilder();
        if (hijoIzq != null) {
            tempStr.append(getHijoIzq().inOrden());
            tempStr.append("-");
        }
        tempStr.append(imprimir());
        if (hijoDer != null) {
            tempStr.append("-");
            tempStr.append(getHijoDer().inOrden());
        }

        return tempStr.toString();
    }
    
    public String imprimir() {
        return (etiqueta.toString());
    }
    
    public INodoArbol eliminar(Comparable unaClave){
        if (unaClave.compareTo(this.getEtiqueta()) < 0){
            if(this.hijoIzq != null){
                this.hijoIzq = hijoIzq.eliminar(unaClave);
            }
            
            return this;
        }
        
        if (unaClave.compareTo(this.getEtiqueta()) > 0){
            if (this.hijoDer != null){
                this.hijoDer = hijoDer.eliminar(unaClave);
            }
            
            return this;
        }
        
        return quitarNodo();
    }
    
    public INodoArbol quitarNodo(){
        INodoArbol elHijo = null;
        INodoArbol elPadre = null;
        
        if (this.hijoIzq == null){  //Le falta el hijo izquierdo o es hoja
            return this.hijoDer;    //Puede retornar un nulo
        }
        
        if (this.hijoDer == null){
            return this.hijoIzq;    //Le falta el hijo derecho
        }
        
        elHijo = (INodoArbol)this.hijoIzq; //Va al subárbol izquierdo
        elPadre = (INodoArbol)this;
        
        while(elHijo.getHijoDer() != null){
            elPadre = elHijo;
            elHijo = (INodoArbol)elHijo.getHijoDer();
        }                                   //El hijo es el más a la derecha del subárbol izquierdo
        
        if(elPadre != this){
            elPadre.setHijoDer(elHijo.getHijoIzq());
            elHijo.setHijoIzq(hijoIzq);
        }
        
        elHijo.setHijoDer(this.hijoDer);
        hijoDer = null;
        hijoIzq = null;
        return elHijo;                  //ElHijo quedará en lugar de this
        
    }
    
 @Override
    public INodoArbol lexicoGraficamenteAnterior(Comparable pClave){
        INodoArbol res1 = null;
        INodoArbol res2 = null;
        INodoArbol retorno = null;
        
        if (this.hijoIzq != null){
            res1 = this.hijoIzq.lexicoGraficamenteAnterior(pClave);
        }
        
        if (this.hijoDer != null){
            res2 = this.hijoDer.lexicoGraficamenteAnterior(pClave);
        }

        if(res2 != null && res2.getEtiqueta().compareTo(pClave) < 0){
            retorno = res2;
        }
        
        if((retorno == null) && (res1 != null) && (res1.getEtiqueta().compareTo(pClave) < 0)){
            retorno = res1;
        }
        
        if (retorno == null){
            retorno = this;
        }else if(retorno != null && retorno.getEtiqueta().compareTo(this.getEtiqueta()) < 0 
                && this.getEtiqueta().compareTo(pClave) < 0){
            retorno = this;
        }
        
        return retorno;
    }
    
    @Override
    public String posOrden() {
        StringBuilder tempStr = new StringBuilder();
        if (hijoIzq != null) {
            tempStr.append(getHijoIzq().inOrden());
            tempStr.append("-");
        }
        if (hijoDer != null) {
            tempStr.append("-");
            tempStr.append(getHijoDer().inOrden());
        }
        tempStr.append(imprimir());
        
        return tempStr.toString();
    }

    @Override
    public String preOrden() {
        StringBuilder tempStr = new StringBuilder();
        tempStr.append(imprimir());
        if (hijoIzq != null) {
            tempStr.append(getHijoIzq().inOrden());
            tempStr.append("-");
        }
        if (hijoDer != null) {
            tempStr.append("-");
            tempStr.append(getHijoDer().inOrden());
        }
        
        return tempStr.toString();
    }

    @Override
    public int getAltura() {
        int der = -1;
        int izq = -1;
        if (this.hijoIzq!= null) {
            izq = this.hijoIzq.getAltura();
        }
        if (this.hijoDer!= null) {
            izq = this.hijoDer.getAltura();
        }
        return (1 + Math.max(der, izq));
    }

    @Override
    public int getTamano() {
        int der = 0;
        int izq = 0;
        if (this.hijoIzq!= null) {
            izq = this.hijoIzq.getTamano();
        }
        if (this.hijoDer!= null) {
            der = this.hijoDer.getTamano();
        }
        return (1 + der + izq);
    }

    @Override
    public int getNivel(Comparable pEtiqueta) {
        int retorno = 0;
        
        if (pEtiqueta.compareTo(this.etiqueta) == 0) {
            retorno = 0;
        } else if (pEtiqueta.compareTo(this.etiqueta) < 0) {
            if (this.hijoIzq == null) {
                retorno = -1;
            } else {
                retorno = this.hijoIzq.getNivel(pEtiqueta);
            }
        } else if (this.hijoDer == null) {
            retorno = -1;
        } else {
            retorno = this.hijoDer.getNivel(pEtiqueta);
        }
        
        retorno += 1;
        return retorno;
    }

    @Override
    public int getHojas() {
        int retorno = 0;
        if (this.hijoIzq != null){
            retorno += this.hijoIzq.getHojas();
        }
        if (this.hijoDer != null){
            retorno += this.hijoDer.getHojas();
        }
        if (this.hijoDer == null && this.hijoDer == null){
            retorno = 1;
        }
        return retorno;
    }
    
    @Override
    public String printInOrden(){
        StringBuilder tempStr = new StringBuilder();
        if (hijoIzq != null) {
            tempStr.append(this.hijoIzq.printInOrden());
        }
        tempStr.append(this.toString());
        if (hijoDer != null) {
            tempStr.append(this.hijoDer.printInOrden());
        }

        return tempStr.toString();
    }
    
    @Override
    public String toString(){
        return "\t" + this.datos.toString();
    }
    
    // </editor-fold>
 
}
