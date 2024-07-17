
/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package UT3.TA02;

/**
 *
 * @author Bettina
 */
public class hashPiola {
    String[] T;
    int m;
    
    public String buscarHash(int clave){
        String[] v = ManejadorArchivosGenerico.leerArchivo("src/claves_buscar.txt");
        int i = 0;
        boolean encontrado = false;
        int comparaciones = 0;
        int n = 10;
        while (i < n && encontrado == false){
            if (v[i].equals(clave)){
                encontrado = true;
                return v[i];
            }
            else{
                i += 1;
            }
           comparaciones += 1;
        }
        return "";
    }
    
    public int insertarHash(int clave){
        int i = 0;
        int contador = 0;
        int j = this.funcionHash(String.valueOf(clave));
        
        while (T[j].isEmpty() || i == m){
            if (T[j].isEmpty()){
                return contador;
            }
            else{
                i++;
            }
            contador++;
        }
        
        return 0;
    }
    
    /**
     * La función consiste en tomar el último caracter de la palabra, 
     * asignarle un valor numérico según su posición en el alfabeto y 
     * efectuar la división entera entre diez para utilizar el resto 
     * de la misma como código.
     * @param clave Palabra solicitada.
     * @return Devuelve el hashcode de la palabra solicitada.
     */
    public int funcionHash(String clave){
        return ((clave.toLowerCase().codePointAt(clave.length()-1)-96)%10);
    }                        
    
}