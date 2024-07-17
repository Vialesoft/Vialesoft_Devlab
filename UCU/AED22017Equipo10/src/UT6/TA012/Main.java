package UT6.TA012;

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
        int[] arreglo = {7,5,2,9,30,11,8,6};
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
        System.out.println("Ordenar por Shell");
        for (int i = 1; i < arreglo2.length; i ++){
            shellSorted += "-" + arreglo2[i];
        }
        System.out.println(shellSorted);
        
        GeneradorDatosGenericos gnd = new GeneradorDatosGenericos();
        
        int[] asc300 = gnd.generarDatosAscendentes(300);
        int[] des300 = gnd.generarDatosDescendentes(300);
        int[] ale300 = gnd.generarDatosAleatorios(300);
        
        int[] asc10000 = gnd.generarDatosAscendentes(30000);
        int[] des10000 = gnd.generarDatosDescendentes(30000);
        int[] ale10000 = gnd.generarDatosAleatorios(30000);
        
        TClasificador clasifica = new TClasificador();
        
        //Inserción
        System.out.println("Orden por Inserción");
        long tiempoAntes = System.nanoTime();
        clasifica.clasificar(asc10000, 4);
        long tiempoDespues = System.nanoTime();
        
        //System.out.println(TClasificador.strArray(asc10000));
        
        double diferencia = (tiempoDespues - tiempoAntes) / Math.pow(10, 6);
        System.out.println("Ascendente 10000: " + diferencia);
        
        tiempoAntes = System.nanoTime();
        clasifica.clasificar(des10000, 4);
        tiempoDespues = System.nanoTime();
        
        //System.out.println(TClasificador.strArray(des10000));
        
        diferencia = (tiempoDespues - tiempoAntes) / Math.pow(10, 6);
        System.out.println("Descendente 10000: " + diferencia);
        
        tiempoAntes = System.nanoTime();
        clasifica.clasificar(ale10000, 4);
        tiempoDespues = System.nanoTime();
        
        //System.out.println(TClasificador.strArray(ale10000));
        
        diferencia = (tiempoDespues - tiempoAntes) / Math.pow(10, 6);
        System.out.println("Aleatorio 10000: " + diferencia);
        
        //
        
    }

}
