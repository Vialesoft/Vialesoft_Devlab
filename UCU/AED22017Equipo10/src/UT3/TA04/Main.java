package UT3.TA04;

/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

/**
 *
 * @author Bettina
 */
public class Main {

    /**
     * @param args the command line arguments
     */
    public static void main(String[] args) {
        
        
        // Se guarda en un vector de strings las palabras claves leidas del archivo
        String[] palabrasClave = ManejadorArchivosGenerico.leerArchivo("src/UT3/TA04/claves_insertar.txt");
        String[] palabrasBuscar = ManejadorArchivosGenerico.leerArchivo("src/UT3/TA04/claves_buscar.txt");
        
        int cantidadPalabras = palabrasClave.length;
        
        double promedioComparacionesBuscarExitosa;
        double promedioComparacionesBuscarNoExitosa;
        double promedioComparacionesInsertar;
        int cantComparacionesInsertar = 0;
        int cantComparacionesBuscarExitoso = 0;
        int cantComparacionesBuscarNoExitoso = 0;
        int insertar;
        int buscar;
        
        double facCarga = 1;
        // Creamos el arbol Hash
        HashPiola hashP = new HashPiola(cantidadPalabras,facCarga);
        
        for (String p : palabrasClave) {
            // Convierte el String p en una clave entera para ser insertada en el Hash Trie.
            int claveIns = Integer.parseInt(p);
            
            // Se imprime mensaje que muestra la clave que se inserta
            System.out.println("Se inserta la clave: " + p);
            
            insertar = hashP.insertarHashCuadratico(claveIns);
            
            cantComparacionesInsertar += Math.abs(insertar);
            // Insertar la palabra p en el trie
            System.out.println(insertar);
        }
        
        for (String p : palabrasBuscar){
            // Convierte el String p en una clave entera para ser insertada en el Hash Trie.
            int claveBus = Integer.parseInt(p);
            
            //Se imprime mensaje que muestra la clave que se busca
            System.out.println("Se busca la clave: " + p);
            
            buscar = hashP.buscarHashCuadratico(claveBus);
            if(buscar < 0){
                cantComparacionesBuscarNoExitoso += Math.abs(buscar);
            }else{
                cantComparacionesBuscarExitoso += Math.abs(buscar);
            }
            
            // Insertar la palabra p en el trie
            System.out.println(buscar);
        }
        
        promedioComparacionesInsertar = (double)cantComparacionesInsertar / (double)palabrasClave.length;
        System.out.println("Promedio Insertar: " + promedioComparacionesInsertar);
        
        promedioComparacionesBuscarExitosa = (double)cantComparacionesBuscarExitoso / (double)palabrasBuscar.length;
        System.out.println("Promedio Buscar: " + promedioComparacionesBuscarExitosa);
        
        promedioComparacionesBuscarNoExitosa = (double)cantComparacionesBuscarNoExitoso / (double)palabrasBuscar.length;
        System.out.println("Promedio Buscar No Exitoso: " + promedioComparacionesBuscarNoExitosa);
        
       
        
        
    }
    
}
