package UCUGrafos;

import Clases.*;
import java.util.LinkedList;

/**
 *
 * @author Lithium582
 */
public class TArista implements IArista {

    protected Comparable etiquetaOrigen;
    protected Comparable etiquetaDestino;
    protected LinkedList<IVuelo> relaciones;

    /**
     * Constructor de TArista
     * @param etiquetaOrigen Aeropuerto origen
     * @param etiquetaDestino Aeropuerto destino
     * @param pRelaciones Lista de relaciones
     */
    public TArista(Comparable etiquetaOrigen, Comparable etiquetaDestino, LinkedList<IVuelo> pRelaciones) {
        this.etiquetaOrigen = etiquetaOrigen;
        this.etiquetaDestino = etiquetaDestino;
        this.relaciones = pRelaciones;
    }
    
    /**
     * Constructor de la clase Arista
     * @param etiquetaOrigen Aeropuerto origen
     * @param etiquetaDestino Aeropuerto destino
     * @param pRelaciones Lista de relaciones
     */
    public TArista(Comparable etiquetaOrigen, Comparable etiquetaDestino, IVuelo pRelacion) {
        this.etiquetaOrigen = etiquetaOrigen;
        this.etiquetaDestino = etiquetaDestino;
        
        relaciones = new LinkedList<IVuelo>();
        relaciones.add(pRelacion);
    }
    
    /**
     * Método que retorna el ID del aeropuerto origen
     * @return Comparable con el ID del aeropuerto origen
     */
    @Override
    public Comparable getEtiquetaOrigen() {
        return etiquetaOrigen;
    }

    /**
     * Método que cambia el valor de la etiqueta origen
     * @param etiquetaOrigen Comparable con el nuevo valor de origen
     */
    @Override
    public void setEtiquetaOrigen(Comparable etiquetaOrigen) {
        this.etiquetaOrigen = etiquetaOrigen;
    }

    /**
     * Método que retorna la etiqueta destino
     * @return Comparable con el valor de la etiqueta destino
     */
    @Override
    public Comparable getEtiquetaDestino() {
        return etiquetaDestino;
    }

    /**
     * Método que cambia el valor de la etiqueta destino
     * @param etiquetaDestino Comparable con el nuevo valor de destino
     */
    @Override
    public void setEtiquetaDestino(Comparable etiquetaDestino) {
        this.etiquetaDestino = etiquetaDestino;
    }

    /**
     * Método que retorna una lista enlazada con los vuelos que conectan los dos aeropuertos
     * @return LinkedList con los vuelos
     */
    @Override
    public LinkedList<IVuelo> getRelaciones() {
        return relaciones;
    }

    /**
     * Método que modifica las relaciones entre dos aeropuertos
     * @param pRelaciones LinkedList con los nuevos vuelos que conectan los aeropuertos
     */
    @Override
    public void setRelaciones(LinkedList<IVuelo> pRelaciones) {
        this.relaciones = pRelaciones;
    }

    
}
