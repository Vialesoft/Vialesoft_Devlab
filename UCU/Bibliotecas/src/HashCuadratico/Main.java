/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package HashCuadratico;

import java.util.ArrayList;
import java.util.Arrays;

/**
 *
 * @author Ignacio
 */
public class Main {

    /**
     * @param args the command line arguments
     */
    public static void main(String[] args) {
        ArrayList<Double> factores = new ArrayList<>(Arrays.asList(0.70, 0.75, 0.80, 0.85, 0.90, 0.91, 0.92, 0.93, 0.94, 0.95, 0.96, 0.97, 0.98, 0.99));
        String[] out = new String[factores.size()];
        int index = 0;

        for (Double factor : factores) {
            String[] claves = ManejadorArchivosGenerico.leerArchivo("./src/claves_insertar.txt");
            THash hash = new THash(claves.length, factor);
            double busquedasConExito = 0;
            double busquedasSinExito = 0;
            double insercionesConExito = 0;
            double insercionesSinExito = 0;

            for (String clave : claves) {
                int insercion = hash.insertar(Integer.parseInt(clave));
                if (insercion > 0) {
                    insercionesConExito += insercion;
                } else {
                    insercionesSinExito += (-insercion);
                }
            }

            String[] buscar = ManejadorArchivosGenerico.leerArchivo("./src/claves_buscar.txt");
            for (String clave : buscar) {
                double busqueda = hash.buscar(Integer.parseInt(clave));
                if (busqueda > 0) {
                    busquedasConExito += busqueda;
                } else {
                    busquedasSinExito += (-busqueda);
                }
            }

            System.out.println("La cantidad de búsquedas con exito es:" + busquedasConExito);
            System.out.println("La cantidad de búsquedas sin exito es:" + busquedasSinExito);
            System.out.println("La cantidad de inserciones con exito es:" + insercionesConExito);
            System.out.println("La cantidad de inserciones sin exito es:" + insercionesSinExito);

            out[index] = (insercionesConExito / hash.getSizeLista()) + ";"
                    + (busquedasConExito / hash.getSizeLista()) + ";"
                    + (busquedasSinExito / hash.getSizeLista());
            index++;
        }
        ManejadorArchivosGenerico.escribirArchivo("./src/out.csv", out);
    }
}
