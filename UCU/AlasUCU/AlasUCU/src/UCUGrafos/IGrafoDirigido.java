package UCUGrafos;

import Clases.*;
import java.util.ArrayList;
import java.util.Collection;
import java.util.Map;

/**
 * 
 * @author Lithium582
 */
public interface IGrafoDirigido {
    /**
     * Metodo encargado de eliminar una arista dada por un origen y destino.
     * En caso de no existir la arista, retorna falso. En caso de que las
     * etiquetas sean invalidas (no existe el vertice origen o el destino), retorna falso.
     * @param nomVerticeOrigen
     * @param nomVerticeDestino
     * @return 
     */
    boolean eliminarArista(Comparable nomVerticeOrigen, Comparable nomVerticeDestino);

    /**
     * Metodo encargado de eliminar un vertice en el grafo. En caso de no
     * existir el vertice, retorna falso. En caso de que la etiqueta sea
     * invalida, retorna false.
     *
     * @param nombreVertice
     * @return 
     */
    boolean eliminarVertice(Comparable nombreVertice);

    /**
     * Retorna el vértice con la etiqueta pasada por parámetro
     * @param unaEtiqueta Comparable representando un código de aeropuerto
     * @return TVertice con el código recibido o null si no se encuentra
     */
    IVertice buscarVertice(Comparable unaEtiqueta);
    
    /**
     * Metodo encargado de verificar la existencia de una arista. Las
     * etiquetas pasadas por parametro deben ser validas (o sea, los vértices origen y destino deben existir en el grafo).
     *
     * @return True si existe la arista, false en caso contrario
     */
    boolean existeArista(Comparable etiquetaOrigen, Comparable etiquetaDestino);

    /**
     * Metodo encargado de verificar la existencia de un vertice dentro del
     * grafo.-
     *
     * La etiqueta especificada como parametro debe ser valida.
     *
     * @param unaEtiqueta Etiqueta del vertice a buscar.-
     * @return True si existe el vertice con la etiqueta indicada, false en caso
     * contrario
     */
    boolean existeVertice(Comparable unaEtiqueta);

    /**
     * Retorna la posición en el hashMap de una clave o -1 si no se encuentra
     * @param pComp Código que se está buscando en el hashMap
     * @return Posición de la clave en el hash o -1 si no se encuentra en ella
     */
    int obtenerPosicionEnElHashMap(Comparable pComp);
    
    /**
     * Retorna la clave para una posición determinada en el hashMap
     * @param pPosicion Posición buscada en el hashMap
     * @return La clave que se encuentra en la posición o cero si no existe
     */
    Comparable obtenerEtiquetaPorPosicion(int pPosicion);
    
    /**
     * Metodo encargado de insertar un vertice en el grafo.
     *
     * No pueden ingresarse vertices con la misma etiqueta. La etiqueta
     * especificada como parametro debe ser valida.
     *
     * @param vertice
     * @return True si se pudo insertar el vertice, false en caso contrario
     */
    boolean insertarVertice(IVertice vertice);

    /**
     * Método que inserta un nuevo vértice a partir de su etiqueta y dato
     * @param unaEtiqueta Comparable con el dato de la etiqueta (el ID del Aeropuerto)
     * @param pObjeto Instancia de Aeropuerto
     * @return Booleano indicando si la inserción fue satisfactoria
     */
    boolean insertarVertice(Comparable unaEtiqueta, Aeropuerto pObjeto);
    
    /**
     * Método que carga un nuevo grafo a partir de una colección de vértices y otra de aristas
     * @param vertices Los vértices
     * @param aristas
     */
    void cargarGrafo(Collection<IVertice> vertices, Collection<IArista> aristas);
    
    /**
     * Método que inserta una arista en el grafo a partir de los datos que la componen
     * @param etiquetaOrigen Comparable con el código del aeropuerto del que parte la arista
     * @param etiquetaDestino Comparable con el código del aeropuerto al que llega la arista
     * @param costo Double con el costo de la arista
     * @return Booleano indicando si la arista se insertó correctamente
     */
    boolean insertarArista(Comparable etiquetaOrigen, Comparable etiquetaDestino, Comparable costo);
    
    /**
     *  Método que inserta una arista en el grafo
     * @param arista Objeto TArista a insertar
     * @return Booleano indicando si la arista se insertó correctamente
     */
    boolean insertarArista(IArista arista);
    
    /**
     * Método que retorna todos los vértices del grafo, resultado de un recorrido en profundidad
     * @return Colección con todos los vértices
     */
    Collection<Comparable> bpf();
    
    /**
     * Método que retorna todos los vértices del grafo, resultado de un recorrido en profundidad
     * 
     * @return Colección con todos los vértices
     */
    Collection<Comparable> bpf(Comparable etiquetaOrigen);
    
    /**
     * Método que retorna todos los vértices del grafo, resultado de un recorrido en profundidad
     * 
     * @return Colección con todos los vértices
     */
    Collection<Comparable> bpf(TVertice verticeOrigen);
    
    /**
     * Método que retorna todos los caminos posibles entre dos vértices, usando una determinada aerolínea
     * y con un máximo determinado de escalas
     * @param etiquetaOrigen Comparable con el ID del Aeropuerto Origen
     * @param etiquetaDestino Comparable con el ID del Aeropuerto Destino
     * @param pCantidadEscalas Integer cantidad máxima de escalas
     * @param pAerolinea Comparable con el ID de la Aerolínea
     * @return Instancia de TCaminos conteniendo todos los caminos posibles
     */
    TCaminos todosLosCaminos(Comparable etiquetaOrigen, Comparable etiquetaDestino, int pCantidadEscalas, Comparable pAerolinea);
    
    /**
     * Método que determina si el grafo tiene un ciclo
     * @return Booleano indicando si el grafo tiene o no un ciclo
     */
    boolean tieneCiclo();
    
    /**
     * Método que retorna todas las etiquetas ordenadas
     * @return Array con todas las etiquetas del grafo
     */
    Object[] getEtiquetasOrdenado();
    
    /**
     * Método que retorna todos los vértices del grafo
     * @return Map con todos los vértices y sus adyacencias
     */
    public Map<Comparable, IVertice> getVertices();
    
    /**
     * Método que marca todos los vértices como desvisitados
     */
    void desvisitarVertices();
}
