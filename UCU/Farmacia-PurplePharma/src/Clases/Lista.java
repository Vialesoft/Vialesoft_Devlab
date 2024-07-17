/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package Clases;

import Interfaces.*;
/**
 * @param <T> Tipo de la lista
 * @author Lithium582
 */

public class Lista<T> implements ILista<T> {

    private INodoLista<T> primero;

    /**
     Constructor de Lista
     */
    public Lista() {
        primero = null;
    }

    /**
     * Constructor de Lista que recibe el primer Nodo.
     * @param pNodo Primer Nodo de la lista.
     */
    public Lista(INodoLista<T> pNodo) {
        this.primero = pNodo;
    }
    
    @Override
    public void Insertar(INodoLista<T> pNodo) {
        INodoLista<T> aux = this.primero;
        pNodo.setSiguiente(null);
        
        if (this.esVacia()) {
            this.primero = pNodo;
        }
        else if (this.primero.getSiguiente() == null){
            if (aux.getEtiqueta().compareTo(pNodo.getEtiqueta()) > 0){
                pNodo.setSiguiente(this.primero);
                this.primero = pNodo;
            }
            else{
                this.primero.setSiguiente(pNodo);
            }
        }
        else{
            if ((aux.getEtiqueta().compareTo(pNodo.getEtiqueta())) > 0){
                pNodo.setSiguiente(aux);
                this.primero = pNodo;
            }
            else{
                Boolean insertado = false;
                while ((aux.getSiguiente() != null)){
                    if (((aux.getSiguiente()).getEtiqueta()).compareTo(pNodo.getEtiqueta()) > 0 && aux.getEtiqueta().compareTo(pNodo.getEtiqueta()) < 0){
                        pNodo.setSiguiente(aux.getSiguiente()); 
                        aux.setSiguiente(pNodo);
                        insertado = true;
                    }
                    else{
                        aux = aux.getSiguiente();
                    }
                }
                
                if (!insertado){
                    aux.setSiguiente(pNodo);
                    //insertado = true;
                }
            }
        }
    }

    @Override
    public INodoLista<T> Buscar(Comparable pId) {
        if (esVacia()) {
            return null;
        } else {
            INodoLista<T> aux = primero;
            while (aux != null) {
                if ((aux.getEtiqueta()).equals(pId)) {
                    return aux;
                }
                aux = aux.getSiguiente();
            }
        }
        return null;
    }

    @Override
    public boolean Borrar(Comparable pId) {
        if (esVacia()) {
            return false;
        }
        if (primero.getSiguiente() == null) {
            if (primero.getEtiqueta().equals(pId)) {
                primero = null;
                return true;
            }
        }
        INodoLista<T> aux = primero;
        if (aux.getEtiqueta().equals(pId)) {
            //Eliminamos el primer elemento
            INodoLista<T> temp = aux.getSiguiente();
            primero = temp;
            return true;
        }
        while (aux.getSiguiente() != null) {
            if (aux.getSiguiente().getEtiqueta().equals(pId)) {
                INodoLista<T> temp = aux.getSiguiente();
                aux.setSiguiente(temp.getSiguiente());
                return true;

            }
            aux = aux.getSiguiente();
        }
        return false;
    }

    @Override
    public String Print() {
        String aux = "";
        if (!esVacia()) {
            INodoLista<T> temp = primero;
            while(temp != null) {
                temp.PrintEtiqueta();
                temp = temp.getSiguiente();
            }
        }
        return aux;
    }
    
    @Override
    public String Print(String pSeparador) {
        String aux = "";
        if (esVacia()) {
            return "";
        } else {
            INodoLista<T> temp = primero;
            aux += "\t" + temp.getObjeto().toString() + "\n";
            while (temp.getSiguiente() != null) {
                //aux += temp.getSiguiente().getEtiqueta().toString() + ":\n";
                aux += "\t" + temp.getSiguiente().getObjeto().toString() + "\n";
                temp = temp.getSiguiente();
            }

        }
        return aux;
    }

    @Override
    public String PrintConTitulo(String pSeparador) {
        String aux = "";
        if (esVacia()) {
            return "";
        } else {
            INodoLista<T> temp = primero;
            aux = temp.getEtiqueta().toString() + ":\n";
            aux += "\t" + temp.getObjeto().toString() + "\n";
            while (temp.getSiguiente() != null) {
                aux += temp.getSiguiente().getEtiqueta().toString() + ":\n";
                aux += temp.getSiguiente().getObjeto().toString() + "\n";
                temp = temp.getSiguiente();
            }

        }
        return aux;
    }

    @Override
    public int CantidadDeElementos() {
        int counter = 0;
        if (esVacia()) {
            System.out.println("Cantidad de elementos 0.");
            return 0;
        } else {
            INodoLista<T> aux = primero;
            while (aux != null) {
                counter++;
                aux = aux.getSiguiente();
            }     
        return counter;
        }
    }

    @Override
    public boolean esVacia() {
        return this.primero == null;
    }

    @Override
    public INodoLista<T> getPrimero() {
        return this.primero;
    }
    
}
