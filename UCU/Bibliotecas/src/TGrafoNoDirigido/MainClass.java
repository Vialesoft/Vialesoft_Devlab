/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package TGrafoNoDirigido;

import java.util.LinkedList;

/**
 *
 * @author Facundo
 */
public class MainClass {

    /**
     * @param args the command line arguments
     */
    public static void main(String[] args) {
        /*TGrafoNoDirigido gd = (TGrafoNoDirigido) UtilGrafos.cargarGrafo("./src/verticesBEA.txt", "./src/aristasBEA.txt",
            false, TGrafoNoDirigido.class);*/

        TGrafoNoDirigido gd = UtilGrafos.cargarGrafo("./src/verticesBEA2.txt", "./src/aristasBEA2.txt",
                false, TGrafoNoDirigido.class);
        
        LinkedList<TVertice> verticesArticulados = gd.puntosArticulacion();
        
        for(TVertice vet : verticesArticulados){
            System.out.println(vet.getEtiqueta());
        }
        
        //System.out.println(gd.esFuertementeConexo());
        //System.out.println(gd.esConexo());
        
        //Object[] etiquetasarray = gd.getEtiquetasOrdenado();
        /*String bean5 = gd.bea();
        System.out.println(bean5);
        
        gd.desvisitarVertices();*/
        
        /*
        TGrafoNoDirigido grafoYEE = gd.Primrose();
        String soyBEA = grafoYEE.bea("a");
        System.out.println(soyBEA);

        gd.desvisitarVertices();*/

        /*
        TGrafoNoDirigido segundoGrafoYEE = gd.ElKruskal();
        String soyOtraBEA = segundoGrafoYEE.bea("j");
        System.out.println("Kruskal " + soyOtraBEA);
*/

    }

}
