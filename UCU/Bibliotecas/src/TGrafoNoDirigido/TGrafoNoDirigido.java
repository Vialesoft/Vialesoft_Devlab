package TGrafoNoDirigido;

import java.util.Collection;
import java.util.LinkedList;

public class TGrafoNoDirigido extends TGrafoDirigido {

    private TAristas aristas = new TAristas();

    public TGrafoNoDirigido(Collection<TVertice> vertices, Collection<TArista> aristas) {
        super(vertices, aristas);
        this.aristas.setAristas(aristas);
    }

    public void cargarArista(Comparable etiquetaOrigen, Comparable etiquetaDestino, Double costo) {
         // para que no falle la busqueda del min y destino
        aristas.insertarAlFinal(new TArista(etiquetaOrigen, etiquetaDestino, costo));
        aristas.insertarAlFinal(new TArista(etiquetaDestino, etiquetaOrigen, costo));
        insertarAdyacencia(etiquetaOrigen, etiquetaDestino, costo);
    }

    // este procedimiento de PRIM usa la lista de aristas expl�cita para
    // resolver. Por claridad y seguridad, se arman listas de v�rtices para
    // trabajar,
    // "VerticesU" y "VerticesV", de forma de hacerlo lo m�s parecido posible al
    // seudoc�digo abstracto.
    // al final devuelve un nuevo grafo no dirigido que es el �rbol abarcador de
    // costo m�nimo obtenido.
    /**
     * Devuelve un nuevo grafo, que es el Arbol Abarcador de Costo Mínimo
     *
     * @return Un Grafo Prim
     */
    public TGrafoNoDirigido Primrose() {
        int costoPrim = 0;
        LinkedList<TVertice> VerticesU = new LinkedList<>();
        LinkedList<TVertice> VerticesV = new LinkedList<>();
        LinkedList<TArista> AristasAAM = new LinkedList<>();

        TArista tempArista = null;

        //Si el grafo está vacío no sigue
        if (this.getVertices().isEmpty()) {
            return null;
        }

        //Agrego a la lista de Vértices V, todos los vértices del grafo sin relacionarse
        for (TVertice v : this.getVertices().values()) {
            VerticesV.add(v);
        }

        // El primer vértice de V pasa a U
        VerticesU.addLast(VerticesV.remove());

        //Mientras queden vértices sin recorrer
        while (!(VerticesV.isEmpty())) {
            tempArista = aristas.buscarMin(VerticesU, VerticesV);

            //No hay conexiones entre V y U, pero sin embargo en V aún quedan vértices...
            //Por tanto, agrego el primer vértice restante de V a U para poder continuar armando el grafo PRIM
            if (tempArista == null) {
                TVertice verticePrueba = VerticesV.remove();
                VerticesU.addLast(verticePrueba);
                System.out.println("Agregado a huevo: " + verticePrueba.getEtiqueta());

                //VerticesU.addLast(VerticesV.remove());
            } else {
                //Sumo el costo de la nueva arista al costo total
                //Agrego el vértice a U, y lo saco de V
                costoPrim += tempArista.getCosto();
                AristasAAM.add(tempArista);
                int i = 0;

                //Busco el vértice en V para agregarlo a U
                for (TVertice v : VerticesV) {
                    boolean esElOrigen = v.getEtiqueta().equals(tempArista.getEtiquetaOrigen());
                    boolean esElDestino = v.getEtiqueta().equals(tempArista.getEtiquetaDestino());

                    if (esElOrigen || esElDestino) {
                        break;
                    }
                    i++;
                }

                //Agrego a U al mismo tiempo que saco de V
                VerticesU.addLast(VerticesV.remove(i));

                System.out.println("Costo: " + tempArista.getCosto() + " Origen: " + tempArista.getEtiquetaOrigen() + " Destino: " + tempArista.getEtiquetaDestino());
            }
        }

        System.out.println("costo AAM: " + costoPrim);
        TGrafoNoDirigido nuevoGrafo = new TGrafoNoDirigido(VerticesU, AristasAAM);
        return nuevoGrafo;
    }

    public boolean insertarAdyacencia(Comparable etiquetaOrigen, Comparable etiquetaDestino, Double costo) {
        TArista aristaOrigen = new TArista(etiquetaOrigen, etiquetaDestino, costo);
        TArista aristaDestino = new TArista(etiquetaDestino, etiquetaOrigen, costo);
        return (this.insertarArista(aristaOrigen) && this.insertarArista(aristaDestino));
    }

    @Override
    public boolean insertarArista(TArista arista) {
        if ((arista.getEtiquetaOrigen() != null) && (arista.getEtiquetaDestino() != null)) {
            TVertice vertOrigen = buscarVertice(arista.getEtiquetaOrigen());
            TVertice vertDestino = buscarVertice(arista.getEtiquetaDestino());
            if ((vertOrigen != null) && (vertDestino != null)) {
                return vertOrigen.insertarAdyacencia(arista.getCosto(), vertDestino) && vertDestino.insertarAdyacencia(arista.getCosto(), vertOrigen);
            }
        }
        return false;
    }

    public boolean esFuertementeConexo() {
        this.desvisitarVertices();
        Collection<TVertice> ver = this.getVertices().values();
        for (TVertice v : ver) {
            for (TVertice u : ver) {
                if (v.getEtiqueta() != u.getEtiqueta()) {
                    TArista aristaUno = aristas.buscar(v.getEtiqueta(), u.getEtiqueta());
                    TArista aristaDos = aristas.buscar(u.getEtiqueta(), v.getEtiqueta());
                    if (aristaUno == null && aristaDos == null) {
                        return false;
                    }
                }
            }
        }
        return true;
    }
    
    public boolean esConexo() {
        this.desvisitarVertices();
        Collection<TVertice> ver = this.getVertices().values();
        boolean esConexo = true;

        for (TVertice v : ver) {
            for (TVertice u : ver) {
                Comparable etiquetaU = u.getEtiqueta();
                Comparable etiquetaV = v.getEtiqueta();
                if(etiquetaU.equals("b") && etiquetaV.equals("c")){
                    int a = 0;
                }
                if (!(etiquetaU.equals(etiquetaV))) {
                    if (this.existeUnCaminoViejo(etiquetaU,etiquetaV)) {
                        esConexo = esConexo && true;
                    } else {
                        esConexo = false;
                    }
                }
            }
        }
        return esConexo;
    }

    public String bea() {
        this.desvisitarVertices();
        String retorno = "";
        if (this.getVertices().isEmpty()) {
            retorno = "El grafo está vacio";
        } else {
            for (TVertice vertV : this.getVertices().values()) {
                if (!vertV.getVisitado()) {
                    retorno += " " + vertV.bea();
                }
            }
        }
        return retorno;
    }

    public String bea(Comparable etiquetaInicial) {
        if (this.getVertices().isEmpty()) {
            return "El grafo está vacio";
        } else {
            TVertice verticeBuscado = this.getVertices().get(etiquetaInicial);

            if (verticeBuscado != null) {
                return verticeBuscado.bea();
            } else {
                return "";
            }
        }
    }

    /**
     * El método del Kruskál!
     *
     * @return
     */
    public TGrafoNoDirigido ElKruskal() {
        int costoKruskal = 0;
        //Copio el objeto Aristas para poder manipularlo sin romper el grafo
        TAristas arist = aristas.copiar();

        LinkedList<TArista> Aristas = new LinkedList();
        Collection<TVertice> V = this.getVertices().values();
        TGrafoNoDirigido nuevoGrafo = new TGrafoNoDirigido(V, Aristas);

        //Como insertamos solo una arista para conectar dos vértices
        //entonces podemos cortar el bucle cuando la cantidad de aristas insertadas
        //sea igual al número de vértices del grafo
        while (arist.getAristas().size() > 0) {
            TArista a = arist.Buscarmenor();

            //Remuevo la arista encontrada
            arist.getAristas().remove(a);

            ///dados 2 vertices necesito saber si ya tengo un camino entre esos 2
            ///si no estan conectados agrego la arista
            ///si estan conectados la quito no la agrego
            if (a != null) {
                if (!nuevoGrafo.existeUnCaminoViejo(a.getEtiquetaOrigen(), a.getEtiquetaDestino())) {
                    costoKruskal += a.getCosto();
                    System.out.println("Costo: " + a.getCosto() + " Origen: " + a.getEtiquetaOrigen() + " Destino: " + a.getEtiquetaDestino());
                    nuevoGrafo.insertarArista(a);
                    Aristas.add(a);
                }
            }

        }

        System.out.println("Costo Kruskal: " + costoKruskal);
        return nuevoGrafo;

    }

    public boolean existeUnCaminoViejo(Comparable etiquetaOrigen, Comparable etiquetaDestino) {
        this.desvisitarVertices();
        TVertice verticeOrigen = this.buscarVertice(etiquetaOrigen);
        boolean existe = false;
        if (verticeOrigen != null) {
            existe = verticeOrigen.existeUnCamino(etiquetaDestino);
        }

        return existe;
    }
    
    public LinkedList<TVertice> puntosArticulacion(){
        this.desvisitarVertices();
        int[] contador = new int[1];
        contador[0] = 0;
        LinkedList<TVertice> listaRetorno = new LinkedList();
        TCamino caminoPrevio = null;
        
        for (TVertice vertV : this.getVertices().values()) {
            caminoPrevio = new TCamino(vertV);
            
            if (!vertV.getVisitado()) {
                vertV.puntosArticulados(listaRetorno, contador, caminoPrevio);
            }
        }
        
        return listaRetorno;
    }
}
