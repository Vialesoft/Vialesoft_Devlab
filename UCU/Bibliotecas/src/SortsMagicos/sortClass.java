/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package SortsMagicos;

import java.util.Arrays;
import java.util.Calendar;
import java.util.LinkedList;

/**
 *
 * @author Alf
 */
public class sortClass {

    private int[] vectorIncremento;

    public sortClass() {
        this.vectorIncremento = new int[]{27479, 22531, 18523, 9007, 2003, 1117, 787, 127, 79, 17, 5, 1};
    }

    //----------------------
    //1 - Insercion directa:
    //----------------------
    public int[] insercionDirecta(int[] vector) {
        int[] copia = vector.clone();
        for (int i = 1; i < copia.length; i++) {
            int aux = copia[i];
            int j = i - 1;
            while (j >= 0 && aux < copia[j]) {
                copia[j + 1] = copia[j];
                j--;
            }
            copia[j + 1] = aux;
        }
        return copia;
    }

    //--------------
    //2 - BubbleSort:
    //--------------
    public int[] bubbleSort(int[] vector) {
        int[] copia = vector.clone();
        boolean ordenado = false;
        int ultimo = vector.length - 1;
        while (!ordenado) {
            ordenado = true;
            for (int i = 0; i < ultimo; i++) {
                if (copia[i] > copia[i + 1]) {
                    int aux = copia[i];
                    copia[i] = copia[i + 1];
                    copia[i + 1] = aux;
                    ordenado = false;
                }
            }
            ultimo--;
        }
        return copia;
    }

    //--------------
    //3 - QuickSort:
    //--------------
    public int[] quickSort(int[] vector) {
        int[] copia = vector.clone();
        return this.quickSort(copia, 0, copia.length - 1);
    }

    private int[] quickSort(int[] vector, int i, int j) {
        if (vector.length > 1) {
            int izq = i;
            int der = j;
            int pivote = vector[izq + (der - izq) / 2];
            while (izq <= der) {
                while ((vector[izq] < pivote) && (izq < j)) {
                    izq++;
                }
                while ((pivote < vector[der]) && (der > i)) {
                    der--;
                }
                if (izq <= der) {
                    int aux = vector[izq];
                    vector[izq] = vector[der];
                    vector[der] = aux;
                    izq++;
                    der--;
                }
            }
            if (i < der) {
                quickSort(vector, i, der);
            }
            if (izq < j) {
                quickSort(vector, izq, j);
            }
        }
        return vector;
    }

    //----------------------
    //4 - Seleccion Directa:
    //----------------------
    public int[] seleccionDirecta(int[] vector) {
        int[] copia = vector.clone();
        for (int i = 0; i < copia.length; i++) {
            int min = i;
            for (int j = i; j < copia.length; j++) {
                if (copia[j] < copia[min]) {
                    min = j;
                }
            }
            int aux = copia[i];
            copia[i] = copia[min];
            copia[min] = aux;
        }
        return copia;
    }

    //-------------
    //5 - HeapSort:
    //-------------
    public int[] heapSort(int[] vector) {
        int[] copia = vector.clone();
        for (int i = copia.length / 2 - 1; i >= 0; i--) {
            hippieficar(copia, copia.length, i);
        }
        for (int i = copia.length - 1; i >= 0; i--) {
            int aux = copia[0];
            copia[0] = copia[i];
            copia[i] = aux;
            hippieficar(copia, i, 0);
        }
        return copia;
    }

    /**
     *
     * @param arr
     * @param n
     * @param i
     */
    private void hippieficar(int arr[], int n, int i) {
        int maximo = i;
        int l = 2 * i + 1;
        int r = 2 * i + 2;
        if (l < n && arr[l] > arr[maximo]) {
            maximo = l;
        }
        if (r < n && arr[r] > arr[maximo]) {
            maximo = r;
        }
        if (maximo != i) {
            int swap = arr[i];
            arr[i] = arr[maximo];
            arr[maximo] = swap;
            hippieficar(arr, n, maximo);
        }
    }

    //-------------
    //6 - shellSort:
    //-------------
    public int[] shellSort(int[] vector) {
        int[] copia = vector.clone();
        int indice = this.calcularVectorIncremento(copia.length);
        while (indice < this.vectorIncremento.length) {
            int incremento = this.vectorIncremento[indice];
            for (int i = incremento; i < copia.length; i++) {
                int aux = copia[i];
                int j = i - incremento;
                while (j >= 0 && aux < copia[j]) {
                    copia[j + incremento] = copia[j];
                    j -= incremento;
                }
                copia[j + incremento] = aux;
            }
            indice++;
        }
        return copia;
    }

    private int calcularVectorIncremento(int valor) {
        for (int i = this.vectorIncremento.length - 1; i >= 0; i--) {
            if (this.vectorIncremento[i] < valor) {
                return i;
            }
        }
        return -1;
    }

    public int[] cuentaPorDistribucion(int[] vector, int menorValor, int mayorValor) {
        int[] copia = vector.clone();
        int[] vectorFinal = new int[copia.length];
        if (menorValor <= mayorValor) {
            int[] cuenta = new int[mayorValor - menorValor + 1];
            for (int j = 0; j < copia.length; j++) {
                cuenta[copia[j] - menorValor]++;
            }
            for (int i = 0; i < cuenta.length - 1; i++) {
                cuenta[i + 1] += cuenta[i];
            }
            for (int j = copia.length - 1; j >= 0; j--) {
                int aux = cuenta[copia[j] - menorValor];
                vectorFinal[aux - 1] = copia[j];
                cuenta[copia[j] - menorValor]--;
            }
        }
        return vectorFinal;
    }

    //Valor seteado por default para llenar los arrays
    public static int valorDefault = -1;
    //Fin valor seteado por default para llenar los arrays
    
    public int[] esUnBaldeSort(int[] vectorP, int cantidadBaldes) {
        int[][] matrizConBaldes = new int[cantidadBaldes][cantidadBaldes];
        
        for(int i = 0; i < matrizConBaldes.length;i++){
            Arrays.fill(matrizConBaldes[i], valorDefault);
        }

        int cantCifras = enontrarMaximaCifra(vectorP);

        for (int i = 0; i < vectorP.length; i++) {
            insertarEnBalde(vectorP[i], matrizConBaldes, cantCifras);
        }

        int[] vectorFinal = new int[vectorP.length];
        Arrays.fill(vectorFinal, valorDefault);
        
        for (int i = 0; i < matrizConBaldes.length; i++) {
            int[] subVectorOrdenado = seleccionDirecta(matrizConBaldes[i]);
            vectorFinal = subConcatenar(vectorFinal, subVectorOrdenado);
        }

        return vectorFinal;
    }

    private int enontrarMaximaCifra(int[] vectorParaEncontrar) {
        int valMax = 0;
        for (int i = 0; i < vectorParaEncontrar.length; i++) {
            if (vectorParaEncontrar[i] > valMax) {
                valMax = vectorParaEncontrar[i];
            }
        }

        return String.valueOf(valMax).length() - 1;
    }

    public void insertarEnBalde(int valor, int[][] matriz, int cantCifras) {
        int valor2 = valor;
        int cantidadBaldes = matriz[0].length;

        for (int i = 0; i < cantCifras; i++) {
            valor2 = valor2 / cantidadBaldes;
        }

        for (int i = 0; i < matriz[valor2].length; i++) {
            if (matriz[valor2][i] == valorDefault) {
                matriz[valor2][i] = valor;
                break;
            }
        }
    }

    public int[] subConcatenar(int[] vector1, int[] vector2) {
        int v1Largo = vector1.length;
        int v2Largo = vector2.length;
        int cantidadElementos = 0;

        for (int i = 0; i < v1Largo + v2Largo; i++) {
            if (i < v1Largo) {
                if (vector1[i] != valorDefault) {
                    cantidadElementos++;
                }
            } else {
                if (vector2[i - v1Largo] != valorDefault) {
                    cantidadElementos++;
                }
            }
        }
        int[] vectorReturn = new int[cantidadElementos];
        int posActualRet = 0;
        for (int i = 0; i < v1Largo + v2Largo; i++) {
            if (i < v1Largo) {
                if (vector1[i] != valorDefault) {
                    vectorReturn[posActualRet] = vector1[i];
                    posActualRet++;
                }
            } else {
                if (vector2[i - v1Largo] != valorDefault) {
                    vectorReturn[posActualRet] = vector2[i - v1Largo];
                    posActualRet++;
                }
            }
        }
        return vectorReturn;
    }

    public int[] countSort(int vector[], int exp) {
        int[] copia = vector.clone();
        int N = copia.length;
        int salida[] = new int[N];
        int i;
        int contador[] = new int[10];

        for (i = 0; i < N; i++) {
            contador[(copia[i] / exp) % 10]++;
        }

        for (i = 1; i < 10; i++) {
            contador[i] += contador[i - 1];
        }

        for (i = N - 1; i >= 0; i--) {
            salida[contador[(copia[i] / exp) % 10] - 1] = copia[i];
            contador[(copia[i] / exp) % 10]--;
        }

        for (i = 0; i < N; i++) {
            copia[i] = salida[i];
        }
        
        return copia;
    }

    public int[] RADIXSort(int[] vector) {
        int max = obtenerMaximo(vector);
        for (int exp = 1; max / exp > 0; exp *= 10) {
            vector = countSort(vector, exp);
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
    
        
    public void countSortRadixFecha(Calendar[] vector, int exp, int posicion) {
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

    public Calendar[] RADIXFecha(Calendar[] vector) {
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
                countSortRadixFecha(vector, exp, pos);
            }
        }
        
        return vector;
    }

}
