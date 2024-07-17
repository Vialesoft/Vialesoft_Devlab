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
import java.util.LinkedList;

public class TTrieSufijosHashMap {

    private TNodoTrieHashMap raiz;

    /**
     *
     * @param palabra
     */
    /*
    public void insertar(String palabra) {
        if (raiz == null) {
            raiz = new TNodoTrieHashMap();
        }
        raiz.insertar(palabra);
    }
     */
    public void insertar(String palabra, int indice) {
        if (raiz == null) {
            raiz = new TNodoTrieHashMap();
        }
        raiz.insertar(palabra, indice);
    }

    public void imprimir() {
        if (raiz != null) {
            raiz.imprimir();
        }
    }

    public LinkedList<String> predecir(String prefijo) {
        if (raiz != null) {
            LinkedList<String> palabras = new LinkedList<String>();
            raiz.predecir(prefijo, palabras);
            return palabras;
        }
        return null;
    }

    public ArrayList<Integer> ocurrenciasPosicionesPatron(String patron) {
        ArrayList<Integer> posiciones = new ArrayList<>();
        ArrayList<Integer> auxArr = new ArrayList<>();
        if (raiz != null) {

            raiz.ocurrenciasPosicionesPatron(patron, posiciones);
            auxArr.add(0, posiciones.size());
            for (int i = 0; i < posiciones.size(); i++) {
                auxArr.add(i + 1, posiciones.get(i));
            }
            return auxArr;
        }
        return auxArr;
    }
}
