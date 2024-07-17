package UT2.TA3;


import java.util.LinkedList;

/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

/**
 *
 * @author ernesto
 */
public interface INodoTrie {

    void imprimir();
    public int buscar(String palabra, int[] contador);
    void insertar(String unaPalabra);
    public void predecir(String prefijo, LinkedList<String> palabras);
    
}
