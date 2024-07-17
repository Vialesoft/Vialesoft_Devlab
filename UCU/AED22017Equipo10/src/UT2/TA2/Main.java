/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package UT2.TA2;

import UT2.TA2.ManejadorArchivosGenerico;

/**
 *
 * @author Lithium582
 */
public class Main {

    /**
     * @param args the command line arguments
     */
    public static void main(String[] args) {
        //System.out.println("HOLU");
        
        //Crear una instancia de un árbol Trie
        //Leer un archivo palabras.txt
        //Para cada palabra encontrada, insertarla en el Trie
        //Por último, imprimir el trie
        String[] p =  ManejadorArchivosGenerico.leerArchivo("C:\\Bettina\\GitHub\\2017AED2Equipo10\\src\\UT2\\palabras.txt", true);
        
        
        
        //Ejemplo del uso del Trie
           TArbolTrie trie = new TArbolTrie();
           
        trie.insertar("casa");
        //for (int c = 0;c<p.length;c++){
        // trie.insertar(p[c]);
        //}
     
        
        
        trie.imprimir();
        
//        System.out.println(trie.buscar("casamiento")); 
        
    }
    
}
