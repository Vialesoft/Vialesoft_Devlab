package UT4.TA05;


import java.util.Collection;
import java.util.LinkedList;

public class TVertice implements IVertice{

    private Comparable etiqueta;
    private LinkedList<TAdyacencia> adyacentes;
    private boolean visitado;
    private Object datos;

    @Override
    public Comparable getEtiqueta() {
        return etiqueta;
    }

    @Override
    public LinkedList<TAdyacencia> getAdyacentes() {
        return adyacentes;
    }

    public TVertice(Comparable unaEtiqueta) {
        this.etiqueta = unaEtiqueta;
        adyacentes = new LinkedList();
        visitado = false;
    }

    @Override
    public void setVisitado(boolean valor) {
        this.visitado = valor;
    }

    @Override
    public boolean getVisitado() {
        return this.visitado;
    }

    @Override
    public TAdyacencia buscarAdyacencia(TVertice verticeDestino) {
        if (verticeDestino != null) {
            return buscarAdyacencia(verticeDestino.getEtiqueta());
        }
        return null;
    }


    public Double obtenerCostoAdyacencia(TVertice verticeDestino) {
        TAdyacencia ady = buscarAdyacencia(verticeDestino);
        if (ady != null) {
            return ady.getCosto();
        }
        return Double.MAX_VALUE;
    }

    @Override
    public boolean insertarAdyacencia(Double costo, TVertice verticeDestino) {
        if (buscarAdyacencia(verticeDestino) == null) {
            TAdyacencia ady = new TAdyacencia(costo, verticeDestino);
            return adyacentes.add(ady);
        }
        return false;
    }

    @Override
    public boolean eliminarAdyacencia(Comparable nomVerticeDestino) {
        TAdyacencia ady = buscarAdyacencia(nomVerticeDestino);
        if (ady != null) {
            adyacentes.remove(ady);
            return true;
        }
        return false;
    }

    @Override
    public TVertice primerAdyacente() {
        if (this.adyacentes.getFirst() != null) {
            return this.adyacentes.getFirst().getDestino();
        }
        return null;
    }

    

    @Override
    public TAdyacencia buscarAdyacencia(Comparable etiquetaDestino) {
        for (TAdyacencia adyacencia : adyacentes) {
            if (adyacencia.getDestino().getEtiqueta().compareTo(etiquetaDestino) == 0) {
                return adyacencia;
            }
        }
        return null;
    }

    @Override
    public Object getDatos() {
        return datos; 
    }

    @Override
    public void bpf(Collection<Comparable> visitados) {
        visitado = true;
        visitados.add(etiqueta);
        for( TAdyacencia w : adyacentes){
            if(! (w.getDestino().visitado))
            {
                w.getDestino().bpf(visitados);
            }
        }
    }

    /**
     * Dado un vértice destino, una estructura del tipo TCamino "caminoPrevio" donde ir adjuntando los vértices incorporados
     * al camino y actualizando en forma acorde el costo total, y una estructura TCaminos "losCaminos" en la que agregar
     * un camino cada vez que se llega al destino
     * @param etiquetaDestino
     * @param caminoPrevio
     * @param losCaminos 
     */
    public TCaminos todosLosCaminos(Comparable etiquetaDestino, TCamino caminoPrevio, TCaminos losCaminos){
        //Seteamos con TRÚE
        this.setVisitado(true);
        
        for(TAdyacencia adyacencia : this.getAdyacentes()){
            TVertice destino = adyacencia.getDestino();
            
            boolean visit = destino.getVisitado();
            if(!destino.getVisitado()){
                if(destino.getEtiqueta().compareTo(etiquetaDestino) == 0){
                    TCamino copia = caminoPrevio.copiar();
                    copia.agregarAdyacencia(adyacencia);
                    losCaminos.getCaminos().add(copia);
                } else{
                    TCamino copia = caminoPrevio.copiar();
                    copia.agregarAdyacencia(adyacencia);
                    //caminoPrevio.agregarAdyacencia(adyacencia);
                    destino.todosLosCaminos(etiquetaDestino, copia, losCaminos);
                }
            }
        }
        
        this.setVisitado(false);
        return losCaminos;
        
    }
    
}
