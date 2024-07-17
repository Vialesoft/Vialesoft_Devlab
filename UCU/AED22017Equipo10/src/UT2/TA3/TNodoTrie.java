package UT2.TA3;



import java.io.Serializable;
import java.util.LinkedList;

public class TNodoTrie implements INodoTrie, Serializable {

    private static final int CANT_CHR_ABECEDARIO = 26;
    private TNodoTrie[] hijos;
    private boolean esPalabra;

    public TNodoTrie() {
        hijos = new TNodoTrie[CANT_CHR_ABECEDARIO];
        esPalabra = false;
    }

    @Override
    public int buscar(String palabra, int[] contador){
        TNodoTrie nodo = this;
        for(int c=0; c<palabra.length();c++){
            int indice = palabra.charAt(c) - 'a';
            if(nodo.hijos[indice]!=null){
                contador[0]++;
                //``¡TNodoTrie hijo = nodo.hijos['c'];
                if(nodo.hijos[indice].esPalabra){
                    return contador[0];
                }else{
                    nodo = nodo.hijos[indice];
                }
            }
            
        }
        return contador[0];
    }
    
    @Override
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

    private void imprimir(String s, TNodoTrie nodo) {
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

    @Override
    public void imprimir() {
        
        imprimir("", this);
    }
    
      private TNodoTrie buscarNodoTrie(String s) {
        TNodoTrie nodo = this;
        for (int c = 0; c < s.length(); c++) {
            int indice = s.charAt(c) - 'a';
            if (nodo.hijos[indice] == null) {
                return null;
            }
            nodo = nodo.hijos[indice];
        }
        return nodo;
    }
    
    /**
   * Metodo que permite mostrar las palabras que se registran en un Trie con el prefijo indicado.
   * @param prefijo
   * @param palabras 
   */
    @Override
    public void predecir(String prefijo, LinkedList<String> palabras) {
        // Se referencia al nodo actual.
        TNodoTrie nodo = this;
        // Se recorre la palabra ingresada como prefijo letra por letra
        for (int c = 0; c < prefijo.length(); c++) {
            // Se guarda como indice, el valor del caracter actual menos el valor de a, ambos en codigo ascii.
            int indice = prefijo.charAt(c) - 'a';
           
            if (nodo.hijos[indice] == null) {
                return;
            }
            // Si el vector de tipo TNodoTrie de hijos del nodo actual no es nulo para ese indice dado, se guarda el TNodoTrie de hijos al nodo actual.
            nodo = nodo.hijos[indice];
        }
        // Se invoca al metodo sobrecargado de predecir, que ademas del prefijo y la lista de palabras,
        // se le pasa el mismo prefijo nuevamente (por si el mismo se encontrara en varios lados), y el nodo actual.
        nodo.predecir(prefijo, prefijo, palabras, nodo);
        
    }
      
    /**
     * Sobrecarga de predecir que se utiliza para cargar en la lista todas las coincidencias.
     * @param s
     * @param prefijo
     * @param palabras
     * @param nodo 
     */
     private void predecir(String s, String prefijo, LinkedList<String> palabras, TNodoTrie nodo) {
        // Si el TNodoTrie no es nulo.
         if (nodo != null) {
             // 
            if (nodo.esPalabra) {
                palabras.add(s);
            }
 
            for (int c = 0; c < CANT_CHR_ABECEDARIO; c++) {
                TNodoTrie hijo = nodo.hijos[c];
                if (hijo != null) {
                    hijo.predecir(s+(char)(c + 'a'), prefijo, palabras, hijo);
                }
            }
        }
    }
}
