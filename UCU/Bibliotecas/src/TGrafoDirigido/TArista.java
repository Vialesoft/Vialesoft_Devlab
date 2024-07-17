package TGrafoDirigido;

/**
 *
 * @author R2-D2
 */
public class TArista implements IArista {

    /**
     *
     */
    protected Comparable etiquetaOrigen;

    /**
     *
     */
    protected Comparable etiquetaDestino;

    /**
     *
     */
    protected double costo;

    /**
     *
     * @param etiquetaOrigen
     * @param etiquetaDestino
     * @param costo
     */
    public TArista(Comparable etiquetaOrigen, Comparable etiquetaDestino, double costo) {
        this.etiquetaOrigen = etiquetaOrigen;
        this.etiquetaDestino = etiquetaDestino;
        this.costo = costo;
    }

    /**
     *
     * @return
     */
    @Override
    public Comparable getEtiquetaOrigen() {
        return etiquetaOrigen;
    }

    /**
     *
     * @param etiquetaOrigen
     */
    @Override
    public void setEtiquetaOrigen(Comparable etiquetaOrigen) {
        this.etiquetaOrigen = etiquetaOrigen;
    }

    /**
     *
     * @return
     */
    @Override
    public Comparable getEtiquetaDestino() {
        return etiquetaDestino;
    }

    /**
     *
     * @param etiquetaDestino
     */
    @Override
    public void setEtiquetaDestino(Comparable etiquetaDestino) {
        this.etiquetaDestino = etiquetaDestino;
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
     * @param costo
     */
    @Override
    public void setCosto(double costo) {
        this.costo = costo;
    }

    
}
