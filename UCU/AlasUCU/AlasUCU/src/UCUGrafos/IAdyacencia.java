package UCUGrafos;

import Clases.*;
import java.util.LinkedList;

/**
 * 
 * @author Lithium582
 */
public interface IAdyacencia {
    /**
     * Retorna el vértice al que apunta la adyacencia
     * @return 
     */
    IVertice getVertice();
    
    /**
     * Retorna las relaciones que representa la adyacencia
     * @return 
     */
    LinkedList<IVuelo> getRelaciones();
    
    /**
     * Retorna la etiqueta del vértice al que apunta la adyacencia
     * @return 
     */
    Comparable getEtiqueta();
    
    /**
     * Agrega una relación a la lista de relaciones de la adyacencia
     * @param pRelacion 
     * @return  
     */
    boolean agregarRelacion(IVuelo pRelacion);
    
}
