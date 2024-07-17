package TrieConPaginas;


import java.util.LinkedList;

/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

/**
 *
 * @author Lithium582
 */

public class TArbolTriePag implements IArbolTriePag {

    private TNodoTriePag raiz;

    @Override
    public void insertar(String palabra, int pPagina) {
        try{
            if (raiz == null) {
                raiz = new TNodoTriePag();
            }
            if(palabra != ""){
                raiz.insertar(palabra,pPagina);
            }
        }catch(Exception err){
            int i = 42;
        }
    }

    @Override
    public void imprimir() {
        if (raiz != null) {
            raiz.imprimir();
        }
    }

    public String imprimirDos() {
        if (raiz != null) {
            return raiz.imprimirDos("",raiz);
        }
        return "";
    }

    @Override
    public int buscar(String palabra) {
        if(raiz == null){
            return 0;
        }
        else{
            int[] cont = new int[1];
            cont[0] = 0;
            return raiz.buscar(palabra,cont);   
        }
    }
    
    @Override
    public LinkedList<String> predecir(String prefijo) {
        LinkedList<String> palabras = new LinkedList<String>();
        if(raiz !=null){
            raiz.predecir(prefijo, palabras);
        }
        return palabras;
    }
    
    public TNodoTriePag buscarNodo(String pCadena){
        if(raiz == null){
            return null;
        }
        else{
            int[] cont = new int[1];
            cont[0] = 0;
            return raiz.buscarNodo(pCadena);   
        }
    }
    
    public static String filtrarPalabra(String unaPalabra) {
        StringBuilder sb = new StringBuilder();
        for (int i = 0; i < unaPalabra.length(); i++) {
            char caracter = unaPalabra.charAt(i);
            if ((caracter >= 'A' && caracter <= 'Z') ||
                (caracter >= 'a' && caracter <= 'z'))
                sb.append(caracter);
        }
        return sb.toString().toLowerCase();
    }
}
