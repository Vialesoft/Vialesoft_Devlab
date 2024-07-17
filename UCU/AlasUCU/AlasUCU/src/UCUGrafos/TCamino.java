package UCUGrafos;

import java.util.ArrayList;
import java.util.LinkedList;

/**
 *
 * @author Lithium582
 */
public class TCamino {
    private IVertice origen;
    private ArrayList<Comparable> otrosVertices;
    private LinkedList<IAdyacencia> otrasAdyacencias; //Lista de la adyacencia que conecta el vértice anterior en la lista con el actual
    private Double costoTotal;
    
    /**
     * Método que retorna el primer vértice del camino
     * @return Vértice desde el que parte el camino
     */
    public IVertice getOrigen(){
        return this.origen;
    }
    
    /**
     * Método que retrona todas las etiquetas que componen el camino
     * @return ArrayList con las etiquetas
     */
    public ArrayList<Comparable> getOtrosVertices(){
        return this.otrosVertices;
    }
    
    /**
     *
     * @return
     */
    public LinkedList<IAdyacencia> getOtrasAdyacencias(){
        return this.otrasAdyacencias;
    }
    
    /**
     * Constructor de TCamino
     * @param v Vértice de origen
     */
    public TCamino(IVertice v){
        this.origen = v;
        this.otrosVertices = new ArrayList<Comparable>();
        this.otrasAdyacencias = new LinkedList<IAdyacencia>();
        this.costoTotal = 0D;
    }
    
    /**
     * Método que inserta una nueva adyacencia
     * @param pObjAdyacencia Objeto adyacencia a insertar
     * @param pCosto Costo asociado a la adyacencia
     * @return Booleano indicando si la inserción fue exitosa
     */
    public boolean agregarAdyacencia(IAdyacencia pObjAdyacencia, Double pCosto){
        boolean resultado = false;
        if(pObjAdyacencia.getVertice() != null){
            Comparable etiquetaDestino = pObjAdyacencia.getEtiqueta();
            String unStringAAgregar = pObjAdyacencia.getVertice().getDatos().getNombre();
            resultado = otrosVertices.add(etiquetaDestino + "(" + unStringAAgregar + ")");
            
            //Si insertó la etiqueta, insertamos la adyacencia
            if(resultado){
                resultado = resultado && otrasAdyacencias.add(pObjAdyacencia);
            }
            
            this.costoTotal += pCosto;
        }
        
        return resultado;
    }
    
    /**
     * Método que elimina la última adyacencia agregada
     * @return Booleano indicando si pudo eliminarse la adyacencia
     */
    public boolean eliminarUltimaAdyacencia(){
        boolean res = false;
        int cantidad = otrosVertices.size();
        res = otrosVertices.remove(cantidad) != null;
        res = res && (otrasAdyacencias.removeLast() != null);
        
        return res;
    }
    
    /**
     * Método que retorna el costo total del camino
     * @return Double indicando el costo del camino
     */
    public Double getCosto(){
        return this.costoTotal;
    }
    
    /**
     * Método que retorna un String con todas las etiquetas en orden
     * @return String indicando el camino desde el origen hasta el último elemento en orden
     */
    public String imprimirEtiquetasStr(){
        String resultado = origen.getEtiqueta().toString() + "(" + this.origen.getDatos().getNombre() + ")";
        
        for(Comparable comp : otrosVertices) {
            resultado += " - " + comp.toString();
        }
        
        resultado += " --> $" + String.valueOf(this.costoTotal);
        return resultado;
    }
    
    /**
     * Método que imprime directamente las etiquetas del camino
     */
    public void imprimirEtiquetas(){
        String resultado = origen.getEtiqueta().toString() + "(" + this.origen.getDatos().getNombre() + ")";
        
        for(Comparable comp : otrosVertices) {
            resultado += " - " + comp.toString();
        }
        
        resultado += " --> $" + String.valueOf(this.costoTotal);
        System.out.println(resultado);
    }
    
    /**
     * Método que copia la instancia actual de TCamino
     * @return TCamino con el mismo estado que this
     */
    public TCamino copiar(){
        IVertice origenCopia = new TVertice(this.origen.getDatos(), this.origen.getEtiqueta());
        TCamino copia = new TCamino(origenCopia);
        origenCopia.getAdyacentes().addAll(this.origen.getAdyacentes());
        copia.getOtrosVertices().addAll(this.getOtrosVertices());
        copia.getOtrasAdyacencias().addAll(this.getOtrasAdyacencias());
        copia.costoTotal = this.costoTotal;
        
        return copia;
    }
    
}
