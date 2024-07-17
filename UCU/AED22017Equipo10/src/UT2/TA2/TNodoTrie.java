/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package UT2.TA2;


/**
 *
 * @author mateoalpuy
 */
public class TNodoTrie {
    private static final int CANT_CHR_ABECEDARIO = 26;
    private TNodoTrie[] hijos;
    private boolean esPalabra;
    
    public TNodoTrie(){
        hijos = new TNodoTrie[CANT_CHR_ABECEDARIO];
        esPalabra = false;
    }
    public void insertar(String unaPalabra) {
    TNodoTrie nodo = this;
        for (int c = 0; c < unaPalabra.length(); c++) {
            int indice = unaPalabra.charAt(c) - 'a';
            if (nodo.hijos[indice] == null) {
                nodo.hijos[indice] = new TNodoTrie();
            }
            nodo = nodo.hijos[indice];
        }
        
        nodo.esPalabra = true;
    }
    public TNodoTrie buscar(String unaPalabra ){
        TNodoTrie tnodo = this;
        for(int c = 0; c < unaPalabra.length();c++){
        int indice = unaPalabra.charAt(c) - 'a';
            if (tnodo.hijos[indice] != null){
                tnodo = tnodo.hijos[indice];
            }
            else
                return null;  
        }
            return tnodo;
    };
    private void imprimir(String s, TNodoTrie nodo){
        if (nodo != null) {
            if (nodo.esPalabra) {
                 System.out.println(s);
            }
    for (int c = 0; c < CANT_CHR_ABECEDARIO; c++) {
        if (nodo.hijos[c] != null) {
            imprimir(s + (char) (c + 'a'), nodo.hijos[c]);
            }
            }
         }
     }
    public void imprimir() {
    imprimir("", this);
    }
        
    }
