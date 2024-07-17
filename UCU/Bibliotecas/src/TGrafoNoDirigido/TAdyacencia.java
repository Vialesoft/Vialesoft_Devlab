package TGrafoNoDirigido;

public class TAdyacencia {
    // hereda etiqueta, en la cual se pondr� la etiqueta del vertice destino

    private Comparable etiqueta;
    private Double costo;
    private TVertice destino;
    
    public Comparable getEtiqueta() {
        return etiqueta;
    }
 
    public Double getCosto() {
        return costo;
    }

    public TVertice getDestino() {
        return destino;
    }

    public TAdyacencia(Double costo, TVertice destino) {
        this.etiqueta = destino.getEtiqueta();
        this.costo = costo;
        this.destino = destino;
    }
}
