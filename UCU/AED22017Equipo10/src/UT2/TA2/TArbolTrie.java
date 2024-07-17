/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package UT2.TA2;

/**
 *
 * @author Lithium582
 */
public class TArbolTrie {
    private TNodoTrie raiz;
    
    public void insertar(String palabra){
        if(raiz == null){
            raiz = new TNodoTrie();
        }
        
        raiz.insertar(palabra);
    }
    
    public void imprimir(){
        if(raiz != null){
            raiz.imprimir();
        }
    }
    
    public TNodoTrie buscar(String palabra){
        if(raiz != null){
            return raiz.buscar(palabra);
        }
        
        return null;
    }
}
