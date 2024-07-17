package UT6.TA01;

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
    }

}
