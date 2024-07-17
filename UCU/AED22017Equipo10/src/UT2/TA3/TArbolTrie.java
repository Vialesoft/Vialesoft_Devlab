package UT2.TA3;


import java.io.Serializable;
import java.util.LinkedList;


public class TArbolTrie implements IArbolTrie,Serializable {

    private TNodoTrie raiz;

    @Override
    public void insertar(String palabra) {
        if (raiz == null) {
            raiz = new TNodoTrie();
        }
        raiz.insertar(palabra);
    }

    @Override
    public void imprimir() {
        if (raiz != null) {
            raiz.imprimir();
        }
    }

    @Override
    public int buscar(String palabra) {
        int[] cont = new int[1];
        cont[0] = 0;
        
        if(this.raiz != null){
            return raiz.buscar(palabra, cont);
       }
        
       return cont[0];
    }

    @Override
    public LinkedList<String> predecir(String prefijo) {
       LinkedList<String> listaRetorno = new LinkedList<>();
        if(this.raiz != null){
           
           raiz.predecir(prefijo, listaRetorno);
       }
        
        return listaRetorno;
    }
    
    
}
