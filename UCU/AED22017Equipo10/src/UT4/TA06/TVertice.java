package UT4.TA06;


import java.util.Collection;
import java.util.LinkedList;

public class TVertice implements IVertice{

    private Comparable etiqueta;
    private LinkedList<TAdyacencia> adyacentes;
    private boolean visitado;
    private boolean esActivo;
    private Object datos;

    @Override
    public Comparable getEtiqueta() {
        return etiqueta;
    }

    @Override
    public LinkedList<TAdyacencia> getAdyacentes() {
        return adyacentes;
    }
    
    public boolean getActivo(){
        return this.esActivo;
    }
    
    public void setActivo(boolean pActivo){
        this.esActivo = pActivo;
    }

    public TVertice(Comparable unaEtiqueta) {
        this.etiqueta = unaEtiqueta;
        this.adyacentes = new LinkedList();
        this.visitado = false;
        this.esActivo = true;
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

    @Override
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
        setVisitado(true);
        visitados.add(this.getEtiqueta());
        for (TAdyacencia adyacente : adyacentes) {
            TVertice vertAdy = adyacente.getDestino();
            if (!vertAdy.getVisitado()) {
                vertAdy.bpf(visitados);
            }
        }
    }

public TCaminos todosLosCaminos(Comparable etVertDest, TCamino caminoPrevio, TCaminos todosLosCaminos) {
        this.setVisitado(true);
        for (TAdyacencia adyacencia : this.getAdyacentes()) {
            TVertice destino = adyacencia.getDestino();
            if (!destino.getVisitado()) {
                if (destino.getEtiqueta().compareTo(etVertDest) == 0) {
                    TCamino copia = caminoPrevio.copiar();
                    copia.agregarAdyacencia(adyacencia);
                    todosLosCaminos.getCaminos().add(copia);
                } else {
                    caminoPrevio.agregarAdyacencia(adyacencia);
                    destino.todosLosCaminos(etVertDest, caminoPrevio, todosLosCaminos);
                    caminoPrevio.eliminarAdyacencia(adyacencia);
                }
            }
        }
        this.setVisitado(false);
        return todosLosCaminos;
    }    

    @Override
    public boolean tieneCiclo(TCamino camino) {
       setVisitado(true);
       boolean tieneCiclo = false;
       camino.getOtrosVertices().add(this.etiqueta);
       
       for (TAdyacencia adyacente : adyacentes) {
            TVertice vertAdy = adyacente.getDestino();
            
            if (!vertAdy.getVisitado()) {
                tieneCiclo = vertAdy.tieneCiclo(camino);
                
                if(tieneCiclo) {
                    return true;
                }
            }else{
                if(camino.getOtrosVertices().contains(vertAdy.etiqueta)){
                    return true;
                }
            }
        }
       
        camino.getOtrosVertices().remove(this.etiqueta);
        return tieneCiclo;
    }

    public boolean tieneCiclo(LinkedList<Comparable> camino) {
       setVisitado(true);
       boolean tieneCiclo = false;
       camino.add(etiqueta);
       
       for (TAdyacencia adyacente : adyacentes) {
            //camino.agregarAdyacencia(adyacente);
            TVertice vertAdy = adyacente.getDestino();
            if (!vertAdy.getVisitado()) {
                tieneCiclo = vertAdy.tieneCiclo(camino);
                if(tieneCiclo) return true;
            }else{
                if(camino.contains(vertAdy.etiqueta)){
                    return true;
                }
            }
        }
       
       camino.remove((etiqueta));
       
        return tieneCiclo;
    }
}
