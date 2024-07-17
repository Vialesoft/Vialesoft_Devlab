package UT7.TA2;

import UT6.TA041.*;
import UT6.TA012.*;
import UT6.TA01.*;

/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

/**
 *
 * @author Agustín
 */
public class Main {
    public static void main(String[] args) {
        /*int[] arreglo = {7,5,2,9,30,11,8,6};
        int[] arreglo2 = {7,5,2,9,30,11,8,6};
        TClasificador clasificador = new TClasificador();
        
        //Método de clasificación por burbuja.
        clasificador.clasificar(arreglo, 3);
        String resultado = arreglo[0] + "";
        for(int i=1; i<arreglo.length; i++){
            resultado += "-" + arreglo[i];
        }
        System.out.println(resultado);
        
        //Método de clasificación por Shell Sort.
        clasificador.clasificar(arreglo2, 2);
        String shellSorted = "" + arreglo2[0];
        System.out.println("Ordenar por QuickSort");
        for (int i = 1; i < arreglo2.length; i ++){
            shellSorted += "-" + arreglo2[i];
        }
        System.out.println(shellSorted);*/
        
        GeneradorDatosGenericos gnd = new GeneradorDatosGenericos();
        
        /*int[] asc300 = gnd.generarDatosAscendentes(300);
        int[] des300 = gnd.generarDatosDescendentes(300);
        int[] ale300 = gnd.generarDatosAleatorios(300);
        
        int[] asc10000 = gnd.generarDatosAscendentes(10000);
        int[] des10000 = gnd.generarDatosDescendentes(10000);
        int[] ale10000 = gnd.generarDatosAleatorios(10000);
        
        TClasificador clasifica = new TClasificador();
        
        //Inserción
        System.out.println("Orden por Insert");
        long tiempoAntes = System.nanoTime();
        clasifica.clasificar(asc10000, 1, true);
        long tiempoDespues = System.nanoTime();
        
        //System.out.println(TClasificador.strArray(asc10000));
        
        double diferencia = (tiempoDespues - tiempoAntes) / Math.pow(10, 6);
        System.out.println("Ascendente 10000: " + diferencia);
        
        tiempoAntes = System.nanoTime();
        clasifica.clasificar(des10000, 1, true);
        tiempoDespues = System.nanoTime();
        
        //System.out.println(TClasificador.strArray(des10000));
        
        diferencia = (tiempoDespues - tiempoAntes) / Math.pow(10, 6);
        System.out.println("Descendente 10000: " + diferencia);
        
        tiempoAntes = System.nanoTime();
        clasifica.clasificar(ale10000, 1, true);
        tiempoDespues = System.nanoTime();
        
        //System.out.println(TClasificador.strArray(ale10000));
        
        diferencia = (tiempoDespues - tiempoAntes) / Math.pow(10, 6);
        System.out.println("Aleatorio 10000: " + diferencia);*/
        
        TClasificador clasif = new TClasificador();
        
        int[] ale10000 = gnd.generarDatosAleatorios(300);
        //HeapSort
        //Aleatorio
        System.out.println("Orden por Jéap");
        long tiempoAntes = System.nanoTime();
        clasif.clasificar(ale10000, 1, false);
        long tiempoDespues = System.nanoTime();
        
        double diferencia = (tiempoDespues - tiempoAntes) / Math.pow(10, 6);
        System.out.println("Aleatorio 10000: " + diferencia);
        clasif.clasificar(ale10000, 5, false);
        
        System.out.println(ArrayToString(ale10000));
        
        //Ascendente
        int[] asc10000 = gnd.generarDatosAscendentes(300);
        
        System.out.println("Orden por Jéap");
        tiempoAntes = System.nanoTime();
        clasif.clasificar(asc10000, 1, false);
        tiempoDespues = System.nanoTime();
        
        diferencia = (tiempoDespues - tiempoAntes) / Math.pow(10, 6);
        System.out.println("Ascendente 10000: " + diferencia);
        
        //Ascendente
        int[] des10000 = gnd.generarDatosDescendentes(300);
        
        System.out.println("Orden por Jéap");
        tiempoAntes = System.nanoTime();
        clasif.clasificar(des10000, 1, false);
        tiempoDespues = System.nanoTime();
        
        diferencia = (tiempoDespues - tiempoAntes) / Math.pow(10, 6);
        System.out.println("Descendente 10000: " + diferencia);
        
    }
    
    public static String ArrayToString(int[] vector) {
        String strRetorno = "";
        if (vector.length > 0) {
            strRetorno = String.valueOf(vector[0]);
            for (int i = 1; i < vector.length; i++) {
                strRetorno += "," + String.valueOf(vector[i]);
            }
        }
        return strRetorno;
    }
    
    protected static int[] ordenarPorInsercionCascara(int[] datosParaClasificar) {
        TClasificador clasificador = new TClasificador();
        long total = 0;
        int cantLlamadas = 0;
        double resolucion = 10/0.01;
        int[] copia = new int[datosParaClasificar.length];
        long tiempo1 = System.nanoTime();
        
        while(total < resolucion){
            cantLlamadas++;
            System.arraycopy(datosParaClasificar, 0, copia, 0, datosParaClasificar.length );
            
            clasificador.clasificar(copia, 1, false);
            long tiempo2 = System.nanoTime();
            total = tiempo2 - tiempo1;
        }
        
        long tiempoMedioAlgoritoBase = total / cantLlamadas;
        
        GeneradorDatosGenericos gnd = new GeneradorDatosGenericos();
        
        datosParaClasificar = gnd.generarDatosAleatorios(10000);
        
        tiempo1 = System.nanoTime();
        total = 0;
        cantLlamadas = 0;
        
        while(total < resolucion){
            cantLlamadas++;
            int[] copiaDos = new int[datosParaClasificar.length];
            System.arraycopy(datosParaClasificar, 0, copiaDos, 0, datosParaClasificar.length );
            
            clasificador.clasificar(copiaDos, 1, true);
            
            long tiempo2 = System.nanoTime();
            total = tiempo2 - tiempo1;
        }
        
        long tiempoMedioCascara = total / cantLlamadas;
        
        long tiempoMedioAlgo = tiempoMedioAlgoritoBase - tiempoMedioCascara;
        
        System.out.println("Tiempo medio Algorito: " + (tiempoMedioAlgoritoBase / Math.pow(10, 6)) + " Tiempo medio Cáscara: " + (tiempoMedioCascara  / Math.pow(10, 6)) + " Tiempo Total: " + (tiempoMedioAlgo  / Math.pow(10, 6)));
        
        return copia;
    }
}
