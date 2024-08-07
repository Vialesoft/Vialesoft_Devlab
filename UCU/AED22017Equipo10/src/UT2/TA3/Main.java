package UT2.TA3;


import java.util.LinkedList;


public class Main {

    /**
     * @param args
     */
    public static void main(String[] args){
        TArbolTrie trie = new TArbolTrie();

        String[] palabrasclave = ManejadorArchivosGenerico.leerArchivo("./src/palabras.txt");
        for (String p : palabrasclave) {
                trie.insertar(p);
        }
        trie.imprimir();       
    }
}