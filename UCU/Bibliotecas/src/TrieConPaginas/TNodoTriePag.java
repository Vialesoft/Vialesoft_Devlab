package TrieConPaginas;

import java.util.LinkedList;

/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

/**
 *
 * @author Lithium582
 */

public class TNodoTriePag implements INodoTriePag {

    private static final int CANT_CHR_ABECEDARIO = 26;
    private TNodoTriePag[] hijos;
    private boolean esPalabra;
    private LinkedList<Integer> paginas;
    
    public LinkedList<Integer> getPaginas(){
        return paginas;
    }

    public TNodoTriePag() {
        hijos = new TNodoTriePag[CANT_CHR_ABECEDARIO];
        esPalabra = false;
    }

    @Override
    public void insertar(String unaPalabra, int pPagina) {
        TNodoTriePag nodo = this;
        
        for (int c = 0; c < unaPalabra.length(); c++) {
            int indice = unaPalabra.charAt(c) - 'a';
            
            if(indice < CANT_CHR_ABECEDARIO && indice >= 0){
                if (nodo.hijos[indice] == null) {
                    nodo.hijos[indice] = new TNodoTriePag();
                }
                nodo = nodo.hijos[indice];
            }
        }
        
        nodo.esPalabra = true;
        nodo.agregarPagina(pPagina);
    }

    private void agregarPagina(int pNumero){
        if(this.paginas == null){
            this.paginas = new LinkedList<Integer>();
        }
        
        if(!this.paginas.contains(pNumero)){
            this.paginas.add(pNumero);
        }
    }
    
    private void imprimir(String s, TNodoTriePag nodo) {
        if (nodo != null) {
            if (nodo.esPalabra) {
                System.out.println(s);
            }
            
            for (int c = 0; c < CANT_CHR_ABECEDARIO; c++) {
                if (nodo.hijos[c] != null) {
                    imprimir(s+(char)(c + 'a'), nodo.hijos[c]);
                }
            }
        }
    }
    
    public String imprimirDos(String s, TNodoTriePag nodo) {
        String s2 ="";
        if (nodo != null) {
            if (nodo.esPalabra) {
                s2=s2 +s;
            }
            for (int c = 0; c < CANT_CHR_ABECEDARIO; c++) {
                if (nodo.hijos[c] != null) {
                    imprimir(s+(char)(c + 'a'), nodo.hijos[c]);
                }
            }
        }
        return s2;
    }

    @Override
    public void imprimir() {
        imprimir("", this);
    }
    
    public int buscar(String palabra, int[] contador){
        TNodoTriePag nodo = this;
        for(int c=0; c<palabra.length();c++){
            int indice = palabra.charAt(c) - 'a';
            
            if(nodo.hijos[indice] != null){
                contador[0]++;
                //``¡TNodoTrie hijo = nodo.hijos['c'];
                if(nodo.hijos[indice].esPalabra){
                    return contador[0];
                }else{
                    nodo = nodo.hijos[indice];
                }
            }
        }
        
        return -1;
    }
    
    public TNodoTriePag buscarNodo(String s) {
        TNodoTriePag nodo = this;
        for (int c = 0; c < s.length(); c++) {
            int indice = s.charAt(c) - 'a';
            if (nodo.hijos[indice] == null) {
                return null;
            }
            nodo = nodo.hijos[indice];
        }
        
        return nodo;
    }
    
    public LinkedList<Integer> buscarPaginas(String s) {
        TNodoTriePag nodo = this;
        for (int c = 0; c < s.length(); c++) {
            int indice = s.charAt(c) - 'a';
            if (nodo.hijos[indice] == null) {
                return null;
            }
            nodo = nodo.hijos[indice];
        }
        if (nodo != null && nodo.esPalabra){
            return nodo.getPaginas();
        } else{
            return null;
        }
    }
    
    private void predecir(String s, String prefijo, LinkedList<String> palabras, TNodoTriePag nodo) {
        if (nodo != null) {
            if (nodo.esPalabra) {
                if(!s.trim().equals("")){
                    palabras.add(s + nodo.getPaginas().toString());
                }
            }
            
            for (int c = 0; c < CANT_CHR_ABECEDARIO; c++) {
                if (nodo.hijos[c] != null) {
                    predecir(s+(char)(c + 'a'),prefijo,palabras, nodo.hijos[c]);
                }
            }
        }
    }

    @Override
    public void predecir(String prefijo, LinkedList<String> palabras) {
        TNodoTriePag nodo = buscarNodo(prefijo);
        if(nodo!= null){
            nodo.predecir(prefijo, prefijo, palabras, nodo);
        }
    }
}