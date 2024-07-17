package UCUGrafos;

import Clases.*;
import java.util.Collection;
import java.util.LinkedList;

/**
 * 
 * @author Lithium582
 */
public interface IVertice {

    /**
     * Método que busca y retorna una adyacencia a partir del vértice destino o null si no se encuentra
     * @param verticeDestino Vértice cuya adyacencia se busca
     * @return Instancia de Adyacencia o null si no existe
     */
    IAdyacencia buscarAdyacencia(IVertice verticeDestino);

    /**
     * Método que busca y retorna una adyacencia a partir del vértice destino o null si no se encuentra
     * @param etiquetaDestino Etiqueta del vértice destino
     * @return Instancia de Adyacencia o null si no existe
     */
    IAdyacencia buscarAdyacencia(Comparable etiquetaDestino);

    /**
     * Método que elimina una adyacencia a partir de su vértice destino
     * @param nomVerticeDestino Vértice cuya adyacencia se quiere eliminar
     * @return Booleano indicando si la eliminación fue exitosa
     */
    boolean eliminarAdyacencia(Comparable nomVerticeDestino);

    /**
     * Método que retorna el estado del vértice
     * @return Booleano indicando si el vértice es activo o no
     */
    boolean getActivo();
    
    /**
     * Método que activa o desactiva un vértice
     * @param pActivo Booleano indicando si se debe desactivar el vértice
     */
    void setActivo(boolean pActivo);
    
    /**
     * Método que retorna todas las adyacencias de un vértice
     * @return Lista enlazada con las adyacencias del vértice
     */
    LinkedList<IAdyacencia> getAdyacentes();

    /**
     * Método que retorna el aeropuerto representado por el vértice
     * @return Objeto aeropuerto incluido en el vértice
     */
    Aeropuerto getDatos();

    /**
     * Método que retorna la etiqueta del vértice
     * @return Comparable indicando la etiqueta
     */
    Comparable getEtiqueta();

    /**
     * Método que retorna si el vértice ya fue visitado o no
     * @return Booleano indicando si fue visitado o no
     */
    boolean getVisitado();

    /**
     * Método que inserta una adyacencia en el vértice a partir de el vértice destino y la lista de vuelos
     * @param pVerticeDestino Objeto Vértice al cual apunta la adyacencia
     * @param pListaRelaciones Lista de vuelos que conectan los vértices
     * @return Booleano indicando si la inserción fue correcta
     */
    boolean insertarAdyacencia(IVertice pVerticeDestino, LinkedList<IVuelo> pListaRelaciones);
    
    /**
     * Método que retorna la primera adyacencia
     * @return Vértice representando el primer adyacente
     */
    IVertice primerAdyacente();

    /**
     * Método que setea el valor de visitado del vértice
     * @param valor Booleano indicando el nuevo estado de visita
     */
    void setVisitado(boolean valor);

    /**
     * Método que reaiza la recorrida en profundidad del vértice
     * @param visitados LinkedList con los vértices ya visitados
     */
    void bpf(Collection<Comparable> visitados);
    
    /**
     * Método que retorna si el grafo tiene ciclos
     * @param camino Camino ya recorrido
     * @return Booleano indicando si el vértice cierra un ciclo
     */
    boolean tieneCiclo(TCamino camino);
    
    /**
     * Método que retorna si el grafo tiene ciclos
     * @param camino Camino ya recorrido
     * @return Booleano indicando si el vértice cierra un ciclo
     */
    boolean tieneCiclo(LinkedList<Comparable> camino);
    
    /**
     * Método que retorna todos los caminos posibles entre dos nodos
     * @param etiquetaDestino Etiqueta destino
     * @param caminoPrevio Camino ya recorrido
     * @param losCaminos Todos los caminos completos ya recorridos
     * @param pCantidadEscalas Cantidad máxima de escalas
     * @param pAerolinea Aerolínea en la que se desea viajar
     * @return Instancia de TCaminos
     */
    TCaminos todosLosCaminos(Comparable etiquetaDestino, TCamino caminoPrevio, TCaminos losCaminos, int pCantidadEscalas, Comparable pAerolinea);
    
}
