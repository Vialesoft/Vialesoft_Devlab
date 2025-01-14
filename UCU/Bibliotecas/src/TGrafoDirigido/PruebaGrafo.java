package TGrafoDirigido;

import java.util.Collection;
import java.util.LinkedList;

/**
 *
 * @author R2-D2
 */
public class PruebaGrafo {

    /**
     *
     * @param args
     */
    public static void main(String[] args) {
        TGrafoDirigido gd = (TGrafoDirigido) UtilGrafos.cargarGrafo("src/UT4/TA05/aeropuertos_1.txt","src/UT4/TA05/conexiones_1.txt",
                false, TGrafoDirigido.class);

        Object[] etiquetasarray = gd.getEtiquetasOrdenado();

        Double[][] matriz = UtilGrafos.obtenerMatrizCostos(gd.getVertices());
        UtilGrafos.imprimirMatrizMejorado(matriz, gd.getVertices(), "Matriz");
//        Double[][] mfloyd = gd.floyd();
//        UtilGrafos.imprimirMatrizMejorado(mfloyd, gd.getVertices(), "Matriz luego de FLOYD");
        for (int i = 0; i < etiquetasarray.length; i++) {
//            System.out.println("excentricidad de " + etiquetasarray[i] + " : " + gd.obtenerExcentricidad((Comparable) etiquetasarray[i]));
        }
        System.out.println();
//        System.out.println("Centro del grafo: " + gd.centroDelGrafo());
       
       /*Collection recorrido = gd.bpf();
       LinkedList<Comparable> recorrido2 = (LinkedList<Comparable>)recorrido;
       for(Comparable e :recorrido2 ){
           System.out.println(e);
       }*/
       
       
       System.out.println("Todos los caminos:\n");
       TCaminos tc = gd.todosLosCaminos("Asuncion", "Montevideo");
       
       tc.imprimir();
       int a = 2;
       
       // imprimir etiquetas del bpf de todo el grafo....
//       Collection recorrido_Asuncion = gd.bpf("Asuncion");
//       LinkedList<Comparable> recorrido3 = (LinkedList<Comparable>)recorrido_Asuncion;
//       for(Comparable f :recorrido3 ){
//           System.out.println(f);
//       }
       // imprimir etiquetas del bpf desde Asunción....
       
       
    }
}
