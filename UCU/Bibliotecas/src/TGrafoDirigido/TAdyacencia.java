package TGrafoDirigido;

/**
 *
 * @author R2-D2
 */
public class TAdyacencia implements IAdyacencia {
   

    private Comparable etiqueta;
    private double costo;
    private TVertice destino;
    
    /**
     *
     * @return
     */
    @Override
    public Comparable getEtiqueta() {
        return etiqueta;
    }
 
    /**
     *
     * @return
     */
    @Override
    public double getCosto() {
        return costo;
    }

    /**
     *
     * @return
     */
    @Override
    public TVertice getDestino() {
        return destino;
    }

    /**
     *
     * @param costo
     * @param destino
     */
    public TAdyacencia(double costo, TVertice destino) {
        this.etiqueta = destino.getEtiqueta();
        this.costo = costo;
        this.destino = destino;
    }
}
