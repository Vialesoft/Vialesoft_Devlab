/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package PrimerParcial2016;

/**
 *
 * @author R2-D2
 */
import java.util.ArrayList;
import java.util.HashMap;
import java.util.LinkedList;

public class TNodoTrieHashMap {

    private final HashMap<Character, TNodoTrieHashMap> hijos;
    private boolean esPalabra;
    private int posicion;

    public boolean isEsPalabra() {
        return esPalabra;
    }

    public void setEsPalabra(boolean esPalabra) {
        this.esPalabra = esPalabra;
    }

    public int getPosicion() {
        return posicion;
    }

    public void setPosicion(int posicion) {
        this.posicion = posicion;
    }

    public TNodoTrieHashMap() {
        hijos = new HashMap<>();
        esPalabra = false;
        posicion = -1;
    }

    /*
    public void insertar(String unaPalabra) {
        TNodoTrieHashMap nodo = this;
        for (int c = 0; c < unaPalabra.length(); c++) {
            Character character = unaPalabra.charAt(c);
            
            nodo = nodo.hijos.get(character);
        }
        nodo.setEsPalabra(true); 
    }
     */
    public void insertar(String unaPalabra, int indice) {
        TNodoTrieHashMap nodo = this;
        for (int c = 0; c < unaPalabra.length(); c++) {
            Character car = unaPalabra.charAt(c);
            if (!nodo.hijos.containsKey(car)) {
                nodo.hijos.put(car, new TNodoTrieHashMap());
            }
            nodo = nodo.hijos.get(car);
        }
        nodo.setEsPalabra(true);
        nodo.setPosicion(indice);
    }

    private void imprimir(String s, TNodoTrieHashMap nodo) {
        if (nodo != null) {
            if (nodo.esPalabra) {
                System.out.println(s + " " + nodo.getPosicion());
            }

            for (Character caracter : nodo.hijos.keySet()) {
                if (nodo.hijos.get(caracter) != null) {
                    imprimir(s + caracter, nodo.hijos.get(caracter));
                }
            }
        }
    }

    public void imprimir() {
        imprimir("", this);
    }

    private void predecir(String s, String prefijo, LinkedList<String> palabras, TNodoTrieHashMap nodo) {
        if (nodo != null) {
            if (nodo.esPalabra) {
                palabras.add(prefijo + s);
            }
            for (Character caracter : nodo.hijos.keySet()) {
                if (nodo.hijos.get(caracter) != null) {
                    predecir(s + caracter, prefijo, palabras, nodo.hijos.get(caracter));
                }
            }
        }
    }

    public void predecir(String prefijo, LinkedList<String> palabras) {
        TNodoTrieHashMap nodo = buscarNodoTrie(prefijo);
        predecir("", prefijo, palabras, nodo);
    }

    private TNodoTrieHashMap buscarNodoTrie(String s) {
        TNodoTrieHashMap nodo = this;
        for (int c = 0; c < s.length(); c++) {
            Character character = s.charAt(c);
            if (nodo.hijos.get(character) == null) {
                return null;
            }
            nodo = nodo.hijos.get(character);
        }
        return nodo;
    }

    private void ocurrenciasPosicionesPatron(String patron, ArrayList<Integer> posiciones, TNodoTrieHashMap nodo) {
        if (nodo != null) {
            if (nodo.esPalabra) {
                posiciones.add(nodo.posicion);
            }
            for (Character caracter : nodo.hijos.keySet()) {
                if (nodo.hijos.get(caracter) != null) {
                    nodo.hijos.get(caracter).ocurrenciasPosicionesPatron(patron, posiciones, nodo.hijos.get(caracter));
                }
            }
        }

    }

    public void ocurrenciasPosicionesPatron(String patron, ArrayList<Integer> posiciones) {
        TNodoTrieHashMap aux = this.buscarNodoTrie(patron);
        ocurrenciasPosicionesPatron(patron, posiciones, aux);

    }
}
