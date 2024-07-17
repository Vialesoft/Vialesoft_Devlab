/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package SortsMagicos;

import java.util.Calendar;
import java.util.Date;

/**
 *
 * @author Lithium582
 */
public class PruebaDate {
    
    public void algo(){
        Calendar[] dates = new Calendar[6];
    }
    
    public void countSort(Calendar[] vector, int exp, int posicion) {
        //Posición indica por cuál de los tres campos de fecha se ordena
        //1-Dia, 2-Mes, 5-Dia
        //Calendar[] copia = vector.clone();
        
        //int N = copia.length;
        int N = vector.length;
        Calendar[] salida = new Calendar[N];
        int i;
        int contador[] = new int[10];

        for (i = 0; i < N; i++) {
            //Calendar fechaActual = copia[i];
            Calendar fechaActual = vector[i];
            int val = fechaActual.get(posicion);
            
            //contador[(copia[i] / exp) % 10]++;
            contador[(val / exp) % 10]++;
        }
        
        for (i = 1; i < 10; i++) {
            contador[i] += contador[i - 1];
        }

        for (i = N - 1; i >= 0; i--) {
            //Calendar fechaActual = copia[i];
            Calendar fechaActual = vector[i];
            int val = fechaActual.get(posicion);
            
            //salida[contador[(copia[i] / exp) % 10] - 1] = copia[i];
            //contador[(copia[i] / exp) % 10]--;
            
            //salida[contador[(val / exp) % 10] - 1] = copia[i];
            salida[contador[(val / exp) % 10] - 1] = vector[i];
            contador[(val / exp) % 10]--;
        }

        for (i = 0; i < N; i++) {
            //copia[i] = salida[i];
            vector[i] = salida[i];
        }
    }

    public Calendar[] RADIXSort(Calendar[] vector) {
        int max = 0;
        int pos = 0;
        for(int i = 1; i <= 3; i++){
            //int max = obtenerMaximo(vector);
            switch(i){
                case 1:{ //Dia
                    max = 31;
                    pos = 5;
                    break;
                }
                case 2:{ //Mes
                    max = 12;
                    pos = 2;
                    break;
                }
                case 3:{ //Año
                    max = 9999;
                    pos = 1;
                    break;
                }
            }
            
            for (int exp = 1; max / exp > 0; exp *= 10) {
                countSort(vector, exp, pos);
            }
        }
        
        return vector;
    }

    /**
     * Metodo que se encarga de recorrer el array y nos devuelve una cadena de
     * caracteres conteniendo todos los elementos del mismo, separados por un
     * guion. Si el array esta vacio, devuelve una cadena vacia.
     *
     * @param vector Vector de elementos.
     * @return Cadena de caracteres conteniendo los elementos del array.
     */
    public String strArray(int[] vector) {
        String strRetorno = "";
        if (vector.length > 0) {
            strRetorno = String.valueOf(vector[0]);
            for (int i = 1; i < vector.length; i++) {
                strRetorno += "-" + String.valueOf(vector[i]);
            }
        }
        return strRetorno;
    }

    /**
     * Metodo encargado de verificar si el conjunto de datos se encuentra
     * ordenado.
     *
     * @param vector Conjunto de datos.
     * @return booleano indicando si el vector se encuentra ordenado o no.
     */
    public boolean estaOrdenado(int[] vector) {
        boolean ordenado = true;
        for (int i = 0; i < vector.length - 1; i++) {
            if (vector[i] > vector[i + 1]) {
                ordenado = false;
                break;
            }
        }
        return ordenado;
    }

    private int obtenerMaximo(int vector[]) {
        int max = vector[0];
        for (int i = 1; i < vector.length; i++) {
            if (vector[i] > max) {
                max = vector[i];
            }
        }
        return max;
    }
}
