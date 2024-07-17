/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package UT3.TA03;

import UT2.TA3.*;
import java.util.LinkedList;

/**
 *
 * @author Agustín
 */
public class MedicionBuscarTrie extends Medible{

    private TArbolTrie arbol;

    public MedicionBuscarTrie(TArbolTrie trie) {
        this.arbol = trie;
    }
    @Override
    public void ejecutar(Object... params) {
        int repeticion = (int) params[0];
        String[] palabras = (String[]) params[1];
        for(int i = 0; i < repeticion; i++){
            for(String palabra : palabras){
                arbol.buscar(palabra);
            }
        }
    }
    @Override
    public Object getObjetoAMedirMemoria() {
        return this.arbol;
    }
}
