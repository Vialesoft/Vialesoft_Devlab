package UT4.TA03;

import UT4.TA03.TArista;
import UT4.TA03.TVertice;
import UT4.TA03.UtilGrafos;
import java.util.Collection;
import java.util.HashMap;
import java.util.LinkedList;
import java.util.Map;
import java.util.Set;
import java.util.TreeMap;

public class TGrafoDirigido implements IGrafoDirigido {

    private Map<Comparable, TVertice> vertices; // vertices del grafo.-
    Double[][] pinkFloyd;

    public TGrafoDirigido(Collection<TVertice> vertices, Collection<TArista> aristas) {
        this.vertices = new HashMap<>();
        for (TVertice vertice : vertices) {
            insertarVertice(vertice.getEtiqueta());
        }
        for (TArista arista : aristas) {
            insertarArista(arista);
        }
    }

    /**
     * Metodo encargado de eliminar una arista dada por un origen y destino.
     * En caso de no existir la adyacencia, retorna falso. En caso de que las
     * etiquetas sean inv�lidas, retorna falso.
     *
     */
    public boolean eliminarArista(Comparable nomVerticeOrigen, Comparable nomVerticeDestino) {
        if ((nomVerticeOrigen != null) && (nomVerticeDestino != null)) {
            TVertice vertOrigen = buscarVertice(nomVerticeOrigen);
            if (vertOrigen != null) {
                return vertOrigen.eliminarAdyacencia(nomVerticeDestino);
            }
        }
        return false;
    }

    /**
     * Metodo encargado de eliminar un vertice en el grafo. En caso de no
     * existir el v�rtice, retorna falso. En caso de que la etiqueta sea
     * inv�lida, retorna false.
     *
     */
    public boolean eliminarVertice(Comparable nombreVertice) {
        if (nombreVertice != null) {
            getVertices().remove(nombreVertice);
            return getVertices().containsKey(nombreVertice);
        }
        return false;
    }

    /**
     * Metodo encargado de verificar la existencia de una arista. Las
     * etiquetas pasadas por par�metro deben ser v�lidas.
     *
     * @return True si existe la adyacencia, false en caso contrario
     */
    public boolean existeArista(Comparable etiquetaOrigen, Comparable etiquetaDestino) {
        TVertice vertOrigen = buscarVertice(etiquetaOrigen);
        TVertice vertDestino = buscarVertice(etiquetaDestino);
        if ((vertOrigen != null) && (vertDestino != null)) {
            return vertOrigen.buscarAdyacencia(vertDestino) != null;
        }
        return false;
    }

    /**
     * Metodo encargado de verificar la existencia de un vertice dentro del
     * grafo.-
     *
     * La etiqueta especificada como par�metro debe ser v�lida.
     *
     * @param unaEtiqueta Etiqueta del v�rtice a buscar.-
     * @return True si existe el vertice con la etiqueta indicada, false en caso
     * contrario
     */
    public boolean existeVertice(Comparable unaEtiqueta) {
        return getVertices().get(unaEtiqueta) != null;
    }

    /**
     * Metodo encargado de verificar buscar un vertice dentro del grafo.-
     *
     * La etiqueta especificada como parametro debe ser valida.
     *
     * @param unaEtiqueta Etiqueta del v�rtice a buscar.-
     * @return El vertice encontrado. En caso de no existir, retorna nulo.
     */
    private TVertice buscarVertice(Comparable unaEtiqueta) {
        return getVertices().get(unaEtiqueta);
    }

    /**
     * Matodo encargado de insertar una arista en el grafo (con un cierto
     * costo), dado su vertice origen y destino.- Para que la arista sea
     * valida, se deben cumplir los siguientes casos: 1) Las etiquetas pasadas
     * por parametros son v�lidas.- 2) Los vertices (origen y destino) existen
     * dentro del grafo.- 3) No es posible ingresar una arista ya existente
     * (miso origen y mismo destino, aunque el costo sea diferente).- 4) El
     * costo debe ser mayor que 0.
     *
     * @return True si se pudo insertar la adyacencia, false en caso contrario
     */
    public boolean insertarArista(TArista arista) {
        if ((arista.getEtiquetaOrigen()!= null) && (arista.getEtiquetaDestino() != null)) {
            TVertice vertOrigen = buscarVertice(arista.getEtiquetaOrigen());
            TVertice vertDestino = buscarVertice(arista.getEtiquetaDestino());
            if ((vertOrigen != null) && (vertDestino != null)) {
                return vertOrigen.insertarAdyacencia(arista.getCosto(), vertDestino);
            }
        }
        return false;
    }
 
    /**
     * Metodo encargado de insertar un vertice en el grafo.
     *
     * No pueden ingresarse v�rtices con la misma etiqueta. La etiqueta
     * especificada como par�metro debe ser v�lida.
     *
     * @param unaEtiqueta Etiqueta del v�rtice a ingresar.
     * @return True si se pudo insertar el vertice, false en caso contrario
     */
    public boolean insertarVertice(Comparable unaEtiqueta) {
        if ((unaEtiqueta != null) && (!existeVertice(unaEtiqueta))) {
            TVertice vert = new TVertice(unaEtiqueta);
            getVertices().put(unaEtiqueta, vert);
            return getVertices().containsKey(unaEtiqueta);
        }
        return false;
    }
    @Override
 
 public boolean insertarVertice(TVertice vertice) {
     Comparable unaEtiqueta = vertice.getEtiqueta();
     if ((unaEtiqueta != null) && (!existeVertice(unaEtiqueta))) {
            getVertices().put(unaEtiqueta, vertice);
            return getVertices().containsKey(unaEtiqueta);
        }
        return false;
    }

      
    
    public Object[] getEtiquetasOrdenado() {
        TreeMap<Comparable, TVertice> mapOrdenado = new TreeMap<>(this.getVertices());
        return mapOrdenado.keySet().toArray();
    }
    
 

    /**
     * @return the vertices
     */
    public Map<Comparable, TVertice> getVertices() {
        return vertices;
    }

    @Override
    public Comparable centroDelGrafo() {
        Set<Comparable> etiquetasVertices = vertices.keySet();
        Object[] VerticesIArr = etiquetasVertices.toArray();
        Comparable maxValue = -1D;
        Comparable currentValue = -1;
        String etiquetaMasGrande = "";
        
        maxValue = this.obtenerExcentricidad(String.valueOf(VerticesIArr[0]));
        
        for(int x = 1; x < VerticesIArr.length; x++){
            currentValue = this.obtenerExcentricidad(String.valueOf(VerticesIArr[x]));
            
            if(currentValue.compareTo(maxValue) < 0){
                maxValue = currentValue;
                etiquetaMasGrande = String.valueOf(VerticesIArr[x]);
            }
        }
        
        return etiquetaMasGrande;
    }

    /**
     * Método Pink Floyd
     * @return una matriz
     */
    @Override
    public Double[][] floyd() {
        //Matriz de Costos (por eso se llama C)
        Double[][] C = UtilGrafos.obtenerMatrizCostos(this.vertices);
        
        int cantVertices = C.length;
        //Matriz de Floyd (por eso se llama A)
        Double[][] A = new Double[cantVertices][cantVertices];
        
        //Matriz de vértices anteriores
        Double[][] P = new Double[cantVertices][cantVertices];
        
        for (int i = 0; i < cantVertices; i++){
            for (int j = 0; j < cantVertices; j++){
                A[i][j] = C[i][j];
                P[i][j] = 0D;
            }
        }
        
        for(int i = 0; i < cantVertices; i++){
            A[i][i] = 0D;
        }
        
        for(int k = 0; k < cantVertices; k++){
            for(int i = 0; i < cantVertices; i++){
                for(int j = 0; j < cantVertices; j++){
                    if((A[i][k] + A[k][j]) < A[i][j]){
                        A[i][j] = (A[i][k] + A[k][j]);
                        P[i][j] = Double.parseDouble(String.valueOf(k));
                    }
                }
            }
        }
        //No podemos retornar P (llora)
        return A;
    }

    @Override
    public Comparable obtenerExcentricidad(Comparable etiquetaVertice) {
        //Double[][] matrizA = this.floyd();
        if(this.pinkFloyd == null){
            this.pinkFloyd = this.floyd();
        }
        
        Set<Comparable> etiquetasVertices = vertices.keySet();
        Object[] VerticesIArr = etiquetasVertices.toArray();
        Double maxValue = -1D;
        
        int indice = -1;
        for(int i = 0; i < VerticesIArr.length; i++){
            if(etiquetaVertice.compareTo(VerticesIArr[i]) == 0){
                indice = i;
                break;
            }
        }
        
        if(indice > -1){
            for (int i = 0; i < VerticesIArr.length; i++){
                Double currentValue = this.pinkFloyd[i][indice];
                
                if(currentValue > maxValue){
                    maxValue = currentValue;
                }
            }
        }
        
        return maxValue;
    }

    @Override
    public boolean[][] warshall() {
        throw new UnsupportedOperationException("Not supported yet."); //To change body of generated methods, choose Tools | Templates.
    }

   
    
}
