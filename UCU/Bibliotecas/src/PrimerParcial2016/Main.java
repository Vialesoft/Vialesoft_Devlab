/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package PrimerParcial2016;

import java.util.ArrayList;

/**
 *
 * @author R2-D2
 */
public class Main {

    public static void main(String[] args) {
        TTrieSufijosHashMap trie = new TTrieSufijosHashMap();
        String eltexto = "bananasenlasmananascuandolasranasnocomenlasanaspanamalozanas";
        
        //Insertar todos los sufijos en el trie, "anotando" la posición del texto (base 0)
        //en que comienza cada sufijo.
        for (int i = 0; i < eltexto.length(); i++) {
            String sufijo = eltexto.substring(i);
            System.out.println(sufijo);
            trie.insertar(sufijo, i);
        }
        
        //Hallar las posiciones del texto en que comienza cada ocurrencia del patrón "ana".
        ArrayList<Integer> posiciones = trie.ocurrenciasPosicionesPatron("ana");
        int contador = 0;
        //Imprimir las posiciones del texto en que se encuentra en patrón "ana".
        for (Integer i : posiciones) {
            if (contador == 0) {
                System.out.println("CANTIDAD OCURRENCIAS:" + i);
            } else {
                System.out.println("posicion: " + i);
            }
            contador++;
        }
    }
}
