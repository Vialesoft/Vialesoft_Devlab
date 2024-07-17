package UCUGrafos;

import Clases.*;
import java.util.Collection;
import java.util.LinkedList;

/**
 *
 * @author Lithium582
 */
public class TVertice implements IVertice {

    private Comparable etiqueta;
    private LinkedList<IAdyacencia> adyacentes;
    private boolean visitado;
    private boolean esActivo;
    private Aeropuerto datos;

    @Override
    public Comparable getEtiqueta() {
        return etiqueta;
    }

    @Override
    public LinkedList<IAdyacencia> getAdyacentes() {
        return adyacentes;
    }

    /**
     * Constructor de TVertice
     * @param pDato Objeto Aeropuerto
     * @param pEtiqueta Etiqueta ID de Aeropuerto
     */
    public TVertice(Aeropuerto pDato, Comparable pEtiqueta) {
        this.etiqueta = pEtiqueta;
        this.datos = pDato;
        this.adyacentes = new LinkedList();
        this.visitado = false;
        this.esActivo = true;
    }

    @Override
    public boolean getVisitado() {
        return this.visitado;
    }

    @Override
    public void setVisitado(boolean valor) {
        this.visitado = valor;
    }

    @Override
    public boolean getActivo() {
        return this.esActivo;
    }

    @Override
    public void setActivo(boolean pActivo) {
        this.esActivo = pActivo;
    }

    @Override
    public IAdyacencia buscarAdyacencia(IVertice verticeDestino) {
        if (verticeDestino != null) {
            return buscarAdyacencia(verticeDestino.getEtiqueta());
        }
        return null;
    }

    @Override
    public boolean insertarAdyacencia(IVertice pVerticeDestino, LinkedList<IVuelo> pListaRelaciones) {
        IAdyacencia objAdyacenciaBuscada = this.buscarAdyacencia(pVerticeDestino.getEtiqueta());
        if (objAdyacenciaBuscada == null) {
            IAdyacencia ady = new TAdyacencia(pVerticeDestino, pListaRelaciones);
            return adyacentes.add(ady);
        } else {
            return objAdyacenciaBuscada.getRelaciones().addAll(pListaRelaciones);
        }
    }

    @Override
    public boolean eliminarAdyacencia(Comparable nomVerticeDestino) {
        IAdyacencia ady = buscarAdyacencia(nomVerticeDestino);
        if (ady != null) {
            adyacentes.remove(ady);
            return true;
        }
        return false;
    }

    @Override
    public IVertice primerAdyacente() {
        if (this.adyacentes.getFirst() != null) {
            return this.adyacentes.getFirst().getVertice();
        }
        return null;
    }

    @Override
    public IAdyacencia buscarAdyacencia(Comparable etiquetaDestino) {
        for (IAdyacencia adyacencia : adyacentes) {
            if (adyacencia.getVertice().getEtiqueta().compareTo(etiquetaDestino) == 0) {
                return adyacencia;
            }
        }
        return null;
    }

    @Override
    public Aeropuerto getDatos() {
        return datos;
    }

    @Override
    public void bpf(Collection<Comparable> visitados) {
        visitado = true;
        visitados.add(etiqueta);
        for (IAdyacencia adyActual : adyacentes) {
            if (!(adyActual.getVertice().getVisitado())) {
                adyActual.getVertice().bpf(visitados);
            }
        }
    }

    @Override
    public TCaminos todosLosCaminos(Comparable etiquetaDestino, TCamino caminoPrevio, TCaminos losCaminos, int pCantidadEscalas, Comparable pAerolinea) {
        //Seteamos con TRÚE
        this.setVisitado(true);

        if (caminoPrevio.getOtrosVertices().size() < (pCantidadEscalas + 1)) {
            for (IAdyacencia adyacencia : this.getAdyacentes()) {
                IVertice destino = adyacencia.getVertice();

                if (!destino.getVisitado()) {
                    LinkedList<IVuelo> listaVuelos = new LinkedList<IVuelo>();
                    Double costo = 0D;
                    for (IVuelo vueloI : adyacencia.getRelaciones()) {
                        if (vueloI.getAerolinea().equals(pAerolinea)) {
                            listaVuelos.add(vueloI);
                            costo += vueloI.getCosto();
                        }
                    }

                    if (listaVuelos.size() > 0) {
                        TAdyacencia objAdy = new TAdyacencia(destino, listaVuelos);

                        TCamino copia = caminoPrevio.copiar();
                        copia.agregarAdyacencia(objAdy, costo);
                        if (destino.getEtiqueta().compareTo(etiquetaDestino) == 0) {
                            losCaminos.agregarCamino(copia);
                            //losCaminos.getCaminos().add(copia);
                        } else {
                            //caminoPrevio.agregarAdyacencia(adyacencia);
                            destino.todosLosCaminos(etiquetaDestino, copia, losCaminos, pCantidadEscalas, pAerolinea);
                        }
                    }
                }
            }
        }

        this.setVisitado(false);
        return losCaminos;
    }

    @Override
    public boolean tieneCiclo(TCamino camino) {
        setVisitado(true);
        boolean tieneCiclo = false;
        camino.getOtrosVertices().add(this.etiqueta);

        for (IAdyacencia adyacente : adyacentes) {
            IVertice vertAdy = adyacente.getVertice();

            if (!vertAdy.getVisitado()) {
                tieneCiclo = vertAdy.tieneCiclo(camino);

                if (tieneCiclo) {
                    return true;
                }
            } else {
                if (camino.getOtrosVertices().contains(vertAdy.getEtiqueta())) {
                    return true;
                }
            }
        }

        camino.getOtrosVertices().remove(this.etiqueta);
        return tieneCiclo;
    }

    @Override
    public boolean tieneCiclo(LinkedList<Comparable> camino) {
        setVisitado(true);
        boolean tieneCiclo = false;
        camino.add(etiqueta);

        for (IAdyacencia adyacente : adyacentes) {
            //camino.agregarAdyacencia(adyacente);
            IVertice vertAdy = adyacente.getVertice();
            if (!vertAdy.getVisitado()) {
                tieneCiclo = vertAdy.tieneCiclo(camino);
                if (tieneCiclo) {
                    return true;
                }
            } else {
                if (camino.contains(vertAdy.getEtiqueta())) {
                    return true;
                }
            }
        }

        camino.remove((etiqueta));

        return tieneCiclo;
    }

}
