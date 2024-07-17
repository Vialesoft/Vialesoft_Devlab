package UCUGrafos;

import Clases.*;
import java.util.ArrayList;
import java.util.Collection;
import java.util.HashMap;
import java.util.LinkedList;
import java.util.Map;
import java.util.Set;
import java.util.TreeMap;

/**
 *
 * @author Lithium582
 */
public class TGrafoDirigido implements IGrafoDirigido {

    private Map<Comparable, IVertice> vertices; //Vértices del grafo, con el tipo del Vértice y de sus Adyacencias

    /**
     * Constructor de la clase TGrafoDirigido
     */
    public TGrafoDirigido() {
        this.vertices = new HashMap<>();
    }

    /**
     * Constructor de la clase TGrafoDirigido
     * @param vertices Lista de vértices
     * @param aristas Lista de aristas
     */
    public TGrafoDirigido(Collection<IVertice> vertices, Collection<IArista> aristas) {
        this.vertices = new HashMap<>();

        this.cargarGrafo(vertices, aristas);
    }
    
    @Override
    public int obtenerPosicionEnElHashMap(Comparable pComp) {
        int i = 0;
        for (Comparable comp : this.getVertices().keySet()) {
            if (comp.equals(pComp)) {
                return i;
            }

            i++;
        }

        return -1;
    }
    
    @Override
    public Comparable obtenerEtiquetaPorPosicion(int pPosicion) {
        int i = 0;
        for (Comparable comp : this.getVertices().keySet()) {
            if (i == pPosicion) {
                return this.getVertices().get(comp).getDatos().toString();
                //return comp;
            }

            i++;
        }

        return null;
    }

    @Override
    public void cargarGrafo(Collection<IVertice> vertices, Collection<IArista> aristas) {
        for (IVertice vertice : vertices) {
            insertarVertice(vertice);
        }

        for (IArista arista : aristas) {
            insertarArista(arista);
        }
    }
    
    public boolean eliminarArista(Comparable nomVerticeOrigen, Comparable nomVerticeDestino) {
        if ((nomVerticeOrigen != null) && (nomVerticeDestino != null)) {
            IVertice vertOrigen = buscarVertice(nomVerticeOrigen);
            if (vertOrigen != null) {
                return vertOrigen.eliminarAdyacencia(nomVerticeDestino);
            }
        }
        return false;
    }

    @Override
    public boolean eliminarVertice(Comparable nombreVertice) {
        IVertice verticeBuscado = this.getVertices().get(nombreVertice);

        if (verticeBuscado.getActivo()) {
            verticeBuscado.setActivo(false);
            return true;
        }

        return false;
    }

    @Override
    public boolean existeArista(Comparable etiquetaOrigen, Comparable etiquetaDestino) {
        IVertice vertOrigen = buscarVertice(etiquetaOrigen);
        IVertice vertDestino = buscarVertice(etiquetaDestino);
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
    public IVertice buscarVertice(Comparable unaEtiqueta) {
        IVertice verticeBuscado = getVertices().get(unaEtiqueta);

        if (verticeBuscado != null) {
            if (verticeBuscado.getActivo()) {
                return verticeBuscado;
            }
        }

        return null;
    }

    @Override
    public boolean insertarArista(IArista arista) {
        if ((arista.getEtiquetaOrigen() != null) && (arista.getEtiquetaDestino() != null)) {
            IVertice vertOrigen = buscarVertice(arista.getEtiquetaOrigen());
            IVertice vertDestino = buscarVertice(arista.getEtiquetaDestino());

            if ((vertOrigen != null) && (vertDestino != null)) {
                return vertOrigen.insertarAdyacencia(vertDestino, arista.getRelaciones());
            }
        }
        return false;
    }

    @Override
    public boolean insertarVertice(Comparable unaEtiqueta, Aeropuerto pObjeto) {
        if ((unaEtiqueta != null) && (!existeVertice(unaEtiqueta))) {
            IVertice vert = new TVertice(pObjeto, unaEtiqueta);
            getVertices().put(unaEtiqueta, vert);
            return getVertices().containsKey(unaEtiqueta);
        }
        return false;
    }

    @Override
    public boolean insertarVertice(IVertice vertice) {
        Comparable unaEtiqueta = vertice.getEtiqueta();
        if ((unaEtiqueta != null) && (!existeVertice(unaEtiqueta))) {
            getVertices().put(unaEtiqueta, vertice);
            return getVertices().containsKey(unaEtiqueta);
        }
        return false;
    }
    
    @Override
    public Object[] getEtiquetasOrdenado() {
        TreeMap<Comparable, IVertice> mapOrdenado = new TreeMap<>(this.getVertices());
        return mapOrdenado.keySet().toArray();
    }
    
    @Override
    public Map<Comparable, IVertice> getVertices() {
        return vertices;
    }
    
    @Override
    public boolean insertarArista(Comparable etiquetaOrigen, Comparable etiquetaDestino, Comparable costo) {
        throw new UnsupportedOperationException("Not supported yet."); //To change body of generated methods, choose Tools | Templates.
    }
    
    @Override
    public Collection<Comparable> bpf() {
        Set<Comparable> clavesVertices = this.vertices.keySet();
        IVertice verticeActual = null;
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

    @Override
    public Collection<Comparable> bpf(Comparable etiquetaOrigen) {
        IVertice verticeActual = null;
        Collection<Comparable> verticesVisitados = new LinkedList<Comparable>();

        verticeActual = this.vertices.get(etiquetaOrigen);
        if (verticeActual == null) {
            return null;
        }

        verticeActual.bpf(verticesVisitados);

        return verticesVisitados;
    }

    @Override
    public Collection<Comparable> bpf(TVertice verticeOrigen) {
        Collection<Comparable> verticesVisitados = new LinkedList<Comparable>();
        verticeOrigen.bpf(verticesVisitados);

        return verticesVisitados;
    }

    @Override
    public TCaminos todosLosCaminos(Comparable etiquetaOrigen, Comparable etiquetaDestino, int pCantidadEscalas, Comparable pAerolinea) {
        IVertice verticeOrigen = this.buscarVertice(etiquetaOrigen);
        IVertice verticeDestino = buscarVertice(etiquetaDestino);

        TCaminos caminos = null;
        TCamino caminoPrevio = new TCamino(verticeOrigen);
        if (verticeOrigen != null && verticeDestino != null) {
            caminos = new TCaminos();
            caminos = verticeOrigen.todosLosCaminos(etiquetaDestino, caminoPrevio, caminos, pCantidadEscalas, pAerolinea);
        }

        this.desvisitarVertices();
        return caminos;
    }

    @Override
    public void desvisitarVertices() {
        for (IVertice vertice : this.vertices.values()) {
            vertice.setVisitado(false);
        }
    }

    @Override
    public boolean tieneCiclo() {
        TCamino camino = null;
        boolean esCiclo = false;

        for (IVertice vertice : this.vertices.values()) {
            if (!vertice.getVisitado()) {
                camino = new TCamino(vertice);
                esCiclo = vertice.tieneCiclo(camino);
            }

            if (esCiclo) {
                return esCiclo;
            }
        }

        return esCiclo;
    }
}
