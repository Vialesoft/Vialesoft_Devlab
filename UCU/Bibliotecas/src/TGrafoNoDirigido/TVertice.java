package TGrafoNoDirigido;

import java.util.Collection;
import java.util.LinkedList;
import java.util.Queue;

public class TVertice {

    private Comparable etiqueta;
    private LinkedList<TAdyacencia> adyacentes;
    private boolean visitado;
    private int numeroBPF;
    private int numeroBajo;

    public Comparable getEtiqueta() {
        return etiqueta;
    }

    public LinkedList<TAdyacencia> getAdyacentes() {
        return adyacentes;
    }

    public TVertice(Comparable unaEtiqueta) {
        this.etiqueta = unaEtiqueta;
        adyacentes = new LinkedList();
        visitado = false;
    }

    private void setVisitado(boolean valor) {
        this.visitado = valor;
    }

    public boolean getVisitado() {
        return this.visitado;
    }

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

    public boolean insertarAdyacencia(Double costo, TVertice verticeDestino) {
        if (buscarAdyacencia(verticeDestino) == null) {
            TAdyacencia ady = new TAdyacencia(costo, verticeDestino);
            return adyacentes.add(ady);
        }
        return false;
    }

    public boolean eliminarAdyacencia(Comparable nomVerticeDestino) {
        TAdyacencia ady = buscarAdyacencia(nomVerticeDestino);
        if (ady != null) {
            adyacentes.remove(ady);
            return true;
        }
        return false;
    }

    public TVertice primerAdyacente() {
        if (this.adyacentes.getFirst() != null) {
            return this.adyacentes.getFirst().getDestino();
        }
        return null;
    }

    public TVertice siguienteAdyacente(TVertice w) {
        TAdyacencia adyacente = buscarAdyacencia(w.getEtiqueta());
        int index = adyacentes.indexOf(adyacente);
        if (index + 1 < adyacentes.size()) {
            return adyacentes.get(index + 1).getDestino();
        }
        return null;
    }

    private TAdyacencia buscarAdyacencia(Comparable etiqueta) {
        for (TAdyacencia adyacencia : adyacentes) {
            if (adyacencia.getDestino().getEtiqueta().compareTo(etiqueta) == 0) {
                return adyacencia;
            }
        }
        return null;
    }

    /**
     * Método inspirado en TODOSLOSCAMINOS
     *
     * @param etVertDest
     * @param caminoPrevio
     * @return
     */
    public boolean existeUnCamino(Comparable etVertDest) {
        this.setVisitado(true);
        boolean retorno = false;
        for (TAdyacencia adyacencia : this.getAdyacentes()) {
            if (retorno) {
                break;
            }
            TVertice destino = adyacencia.getDestino();
            if (!destino.getVisitado()) {
                if (destino.getEtiqueta().compareTo(etVertDest) == 0) {
                    retorno = true;
                } else {
                    retorno = destino.existeUnCamino(etVertDest);
                }
            }
        }
        this.setVisitado(false);
        return retorno;
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

    public String bpf() {
        StringBuilder tempStr = new StringBuilder();
        Collection<Comparable> listaBpf = new LinkedList<>();
        this.bpf(listaBpf);
        for (Comparable etiqueta : listaBpf) {
            tempStr.append(etiqueta + " ; ");
        }
        return tempStr.toString();
    }

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

    public boolean tieneCiclo(TCamino camino) {
        setVisitado(true);
        boolean ciclo = false;
        for (TAdyacencia adyacencia : this.getAdyacentes()) {
            if (ciclo) {
                break;
            }
            TVertice w = adyacencia.getDestino();
            if (!w.getVisitado()) {
                camino.agregarAdyacencia(adyacencia);
                ciclo = w.tieneCiclo(camino);
            } else {
                ciclo = true;
                System.out.println("hay ciclo : " + camino.imprimirDesdeClave(w.etiqueta));
            }
        }
        camino.getOtrosVertices().remove(this.getEtiqueta());
        return ciclo;
    }

    public String bea() {
        String tempStr = "";
        Queue<TVertice> cola = new LinkedList<>();
        this.setVisitado(true);
        cola.add(this);
        tempStr += this.getEtiqueta();
        while (!cola.isEmpty()) {
            TVertice v = cola.poll();
            for (TAdyacencia i : v.adyacentes) {
                if (!i.getDestino().getVisitado()) {
                    i.getDestino().setVisitado(true);
                    cola.add(i.getDestino());
                    tempStr += i.getDestino().getEtiqueta();
                }
            }
        }
        return tempStr;
    }
    
    public int puntosArticulados(LinkedList<TVertice> coleccionArticulados, int[] contador, TCamino caminoPrev){
        if(this.visitado){
            return this.numeroBPF;
        } else{
            this.setVisitado(true);
            Comparable etiquetaPadre = "";
            boolean soyRaiz = true;
            if(! this.etiqueta.equals(caminoPrev.getOrigen().getEtiqueta())){
                etiquetaPadre = caminoPrev.getOtrosVertices().getLast(); //Extraigo al último vértice en la llamada recursiva
                soyRaiz = false;
            }
            //Me agrego
            caminoPrev.getOtrosVertices().add(this.etiqueta);
            this.numeroBPF = ++contador[0];
            int bajoParcial = Integer.MAX_VALUE;
            int bajoMaximo = -1;
            int valorRetrocesosParcial = Integer.MAX_VALUE;
            int cantHijosArbolBPF = 0;
            for (TAdyacencia adyacencia : this.getAdyacentes()) {
                TVertice destino = adyacencia.getDestino();
                if (!destino.getVisitado()) { //ES UN HIJO
                    cantHijosArbolBPF++;
                    int bajoActual = destino.puntosArticulados(coleccionArticulados, contador, caminoPrev);
                    bajoParcial = Math.min(bajoParcial, bajoActual);
                    bajoMaximo = Math.max(bajoMaximo, bajoActual);
                } else {
                    if(!(destino.getEtiqueta().equals(etiquetaPadre))){ //ES ARCO DE RETROCESO
                        int vertRetrocesoActual = destino.puntosArticulados(coleccionArticulados, contador, caminoPrev);
                    
                        valorRetrocesosParcial = Math.min(vertRetrocesoActual, valorRetrocesosParcial);
                    }
                }
                this.numeroBajo = Math.min(Math.min(this.numeroBPF,bajoParcial),valorRetrocesosParcial);
            }
            System.out.println(this.getEtiqueta() + " bajo: " + this.numeroBajo + " BPF: " + this.numeroBPF + " MáximoBajo: " + bajoMaximo);
            if(bajoMaximo >= this.numeroBPF){
                if(!soyRaiz || (soyRaiz && cantHijosArbolBPF > 1)){
                    coleccionArticulados.add(this);
                }
            }
            caminoPrev.getOtrosVertices().removeLast();
            return this.numeroBajo;
        }
    }
    
    public void desvisitar(){
        this.setVisitado(false);
        this.numeroBPF = Integer.MAX_VALUE;
        this.numeroBajo = Integer.MAX_VALUE;
    }
    
}