/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package TSimpleTrie;

/**
 *
 * @author R2-D2
 */
public class RandomMethods {
    
    public static String[] obtenerSufijos(String palabra){
        String[] sufijos = new String[palabra.length()];
        for (int i = 0; i < palabra.length(); i++){
            sufijos[i] = palabra.substring(palabra.length() - i - 1 ,palabra.length());
        }
        return sufijos;
    }
    
    public static TArbolTrie armarArbolSufijos(String palabra){
        TArbolTrie arbol = new TArbolTrie();
        String[] sufijos = RandomMethods.obtenerSufijos(palabra);
        for (String s : sufijos){
            arbol.insertar(s);
        }
        return arbol;
    }
    
    
}
