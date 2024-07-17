package TGrafoDirigido;

import java.util.Collection;
import java.util.HashMap;
import java.util.LinkedList;
import java.util.Map;
import java.util.Set;
import java.util.TreeMap;

/**
 *
 * @author Ernesto
 */
public class TGrafoDirigido implements IGrafoDirigido {

    private Map<Comparable, TVertice> vertices; // vertices del grafo.

    /**
     *
     */
    public Collection<Comparable> verticesVisitados;

    /**
     *
     * @param vertices
     * @param aristas
     */
    public TGrafoDirigido(Collection<TVertice> vertices, Collection<TArista> aristas) {
        this.vertices = new HashMap<>();
        for (TVertice vertice : vertices) {
            this.insertarVertice(vertice.getEtiqueta());
        }
        for (TArista arista : aristas) {
            this.insertarArista(arista);
        }
    }

    @Override
    public boolean eliminarArista(Comparable nomVerticeOrigen, Comparable nomVerticeDestino) {
        if ((nomVerticeOrigen != null) && (nomVerticeDestino != null)) {
            TVertice vertOrigen = buscarVertice(nomVerticeOrigen);
            if (vertOrigen != null) {
                return vertOrigen.eliminarAdyacencia(nomVerticeDestino);
            }
        }
        return false;
    }

    @Override
    public boolean eliminarVertice(Comparable nombreVertice) {
        if (nombreVertice != null) {
            getVertices().remove(nombreVertice);
            return getVertices().containsKey(nombreVertice);
        }
        return false;
    }

    @Override
    public boolean existeArista(Comparable etiquetaOrigen, Comparable etiquetaDestino) {
        TVertice vertOrigen = buscarVertice(etiquetaOrigen);
        TVertice vertDestino = buscarVertice(etiquetaDestino);
        if ((vertOrigen != null) && (vertDestino != null)) {
            return vertOrigen.buscarAdyacencia(vertDestino) != null;
        }
        return false;
    }

    @Override
    public boolean existeVertice(Comparable unaEtiqueta) {
        return getVertices().get(unaEtiqueta) != null;
    }

    @Override
    public boolean insertarArista(TArista arista) {
        if ((arista.getEtiquetaOrigen() != null) && (arista.getEtiquetaDestino() != null)) {
            TVertice vertOrigen = buscarVertice(arista.getEtiquetaOrigen());
            TVertice vertDestino = buscarVertice(arista.getEtiquetaDestino());
            if ((vertOrigen != null) && (vertDestino != null)) {
                return vertOrigen.insertarAdyacencia(arista.getCosto(), vertDestino);
            }
        }
        return false;
    }

    @Override
    public boolean insertarVertice(Comparable unaEtiqueta) {
        if ((unaEtiqueta != null) && (!existeVertice(unaEtiqueta))) {
            TVertice vert = new TVertice(unaEtiqueta);
            getVertices().put(unaEtiqueta, vert);
            return getVertices().containsKey(unaEtiqueta);
        }
        return false;
    }

    /**
     *
     * @param vertice
     * @return
     */
    public boolean insertarVertice(TVertice vertice) {
        Comparable unaEtiqueta = vertice.getEtiqueta();
        if ((unaEtiqueta != null) && (!existeVertice(unaEtiqueta))) {
            getVertices().put(unaEtiqueta, vertice);
            return getVertices().containsKey(unaEtiqueta);
        }
        return false;
    }

    /**
     *
     * @return
     */
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
        Double menorExcentricidad = Double.MAX_VALUE;
        Comparable etiquetaMenorEx = null;
        for (Comparable etiqueta : getVertices().keySet()) {
            Double excentricidadVert = obtenerExcentricidad(etiqueta);
            if (menorExcentricidad.compareTo(excentricidadVert) > 0) {
                menorExcentricidad = excentricidadVert;
                etiquetaMenorEx = etiqueta;
            }
        }
        return etiquetaMenorEx;
    }

    @Override
    public Double[][] floyd() {
        Double[][] A = UtilGrafos.obtenerMatrizCostos(vertices);
        Double[][] p = new Double[A.length][A.length];

        for (int i = 0; i < A.length; i++) {
            A[i][i] = 0.0;
            for (int j = 0; j < A.length; j++) {
                p[i][j] = 0.0;
            }
        }
        for (int k = 0; k < A.length; k++) {
            for (int i = 0; i < A.length; i++) {
                for (int j = 0; j < A.length; j++) {
                    if (A[i][k] + A[k][j] < A[i][j]) {
                        A[i][j] = A[i][k] + A[k][j];
                        p[i][j] = new Double(k);
                    }
                }
            }
        }
        return A;
    }

    /**
     * Nos devuelve la exentricidad del grafo.
     *
     * @param etiquetaVertice
     * @return
     */
    @Override
    public Double obtenerExcentricidad(Comparable etiquetaVertice) {
        Double resultado = 0d;
        Double matrizCaminosMinimos[][] = floyd();
        TVertice origen = getVertices().get(etiquetaVertice);
        //para conocer el �ndice en la matriz del vertice seleccionado como origen
        int indiceOrigen = 0;
        for (Comparable auxiliarContar : getVertices().keySet()) {
            if (auxiliarContar == origen.getEtiqueta()) {
                break;
            }
            indiceOrigen++;
        }

        for (int x = 0; x < matrizCaminosMinimos.length; x++) {
            Double camino = matrizCaminosMinimos[x][indiceOrigen];
            if (camino == null) {
                camino = Double.MAX_VALUE;
            }
            if (x != indiceOrigen && resultado.compareTo(camino) < 0) {
                resultado = camino;
            }
        }
        return resultado;
    }

    @Override
    public boolean[][] warshall() {
        Double[][] matrizCostos = UtilGrafos.obtenerMatrizCostos(getVertices());
        boolean[][] matrizWarshall = new boolean[matrizCostos.length][matrizCostos.length];
        for (int i = 0; i < matrizCostos.length; i++) {
            for (int j = 0; j < matrizCostos.length; j++) {
                matrizWarshall[i][j] = false;

                if (i != j && matrizCostos[i][j] != Integer.MAX_VALUE) {
                    matrizWarshall[i][j] = true;
                }
            }
        }
        for (int k = 0; k < matrizWarshall.length; k++) {
            for (int i = 0; i < matrizWarshall.length; i++) {
                for (int j = 0; j < matrizWarshall.length; j++) {
                    if ((i != k) && (k != j) && (i != j)) {
                        if (!matrizWarshall[i][j]) {
                            matrizWarshall[i][j] = matrizWarshall[i][k] && matrizWarshall[k][j];
                        }
                    }
                }
            }
        }
        return matrizWarshall;
    }

    @Override
    public boolean insertarArista(Comparable etiquetaOrigen, Comparable etiquetaDestino, Double costo) {
        return this.insertarArista(new TArista(etiquetaOrigen, etiquetaDestino, costo));
    }

    /**
     * Busqueda en profundidad para todos los vertices del grafo.
     *
     * @return
     */
    @Override
    public Collection<Comparable> bpf() {
        Set<Comparable> clavesVertices = this.vertices.keySet();
        TVertice verticeActual = null;
        //Diamante ?
        Collection<Comparable> verticesVisitados = new LinkedList<>();
        for (Comparable c : clavesVertices) {
            verticeActual = this.vertices.get(c);
            if (!(verticeActual.getVisitado())) {
                verticeActual.bpf(verticesVisitados);
            }
        }
        return verticesVisitados;
    }

    /**
     *
     * @param etiquetaOrigen
     * @return
     */
    @Override
    public Collection<Comparable> bpf(Comparable etiquetaOrigen) {
        TVertice verticeActual = null;
        if (verticesVisitados == null) {
            verticesVisitados = new LinkedList<Comparable>();
        }

        verticeActual = this.vertices.get(etiquetaOrigen);
        verticeActual.bpf(verticesVisitados);

        return verticesVisitados;
    }

    /**
     *
     * @param verticeOrigen
     * @return
     */
    @Override
    public Collection<Comparable> bpf(TVertice verticeOrigen) {

        verticeOrigen.bpf(verticesVisitados);

        return verticesVisitados;
    }

    /**
     *
     * @param etiquetaOrigen
     * @param etiquetaDestino
     * @return
     */
    public TCaminos todosLosCaminos(Comparable etiquetaOrigen, Comparable etiquetaDestino) {
        TVertice verticeOrigen = this.buscarVertice(etiquetaOrigen);
        TCaminos caminos = null;
        TCamino caminoPrevio = new TCamino(verticeOrigen);
        if (verticeOrigen != null) {
            caminos = new TCaminos();
            caminos = verticeOrigen.todosLosCaminos(etiquetaDestino, caminoPrevio, caminos);
        }
        return caminos;
    }

    /**
     *
     * @return
     */
    @Override
    public boolean tieneCiclo() {
        boolean flag = false;
        for (Comparable key : this.vertices.keySet()) {
            TVertice vertice = this.vertices.get(key);
            if (!vertice.getVisitado()) {
                TCamino camino = new TCamino(vertice);
                flag = vertice.tieneCiclo(camino);
                if (flag) {
                    return flag;
                }
            }
        }
        return false;
    }

    /**
     *
     */
    public void desvisitarVertices() {
        for (TVertice vertice : this.vertices.values()) {
            vertice.setVisitado(false);
        }
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
}
