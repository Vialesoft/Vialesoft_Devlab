package TGrafoNoDirigido;

import java.util.Collection;
import java.util.LinkedList;

public class TAristas {

    private final static String SEPARADOR_ELEMENTOS_IMPRESOS = "-";
    private Collection<TArista> aristas = new LinkedList<TArista>(); // = new {IMPLEMENTACION DE COLLECTION DESEADA}
    
    
    /**
     * Busca dentro de la lista de aristas una arista que conecte a 
     * etOrigen con etDestino
     * @param etOrigen
     * @param etDestino
     * @return 
     */
    public TArista buscar(Comparable etOrigen, Comparable etDestino) {
        //TODO: Implementar busqueda de aristas sobre coleccion	
        Collection<TArista> ari =  this.getAristas();
        for(TArista actual : ari)
        {
            if(actual.getEtiquetaOrigen().equals(etOrigen) && actual.getEtiquetaDestino().equals(etDestino))
            {
                return actual;
            }   
        }
        return null;
    }

    /**
     * Busca la arista de menor costo que conecte a cualquier nodo de
     * VerticesU con cualquier otro de VerticesV y cuyo costo sea el minimo
     * @param VerticesU - Lista de vertices U
     * @param VerticesV - Lista de vertices V
     * @return 
     */
    public TArista buscarMin(Collection<TVertice> VerticesU, Collection<TVertice> VerticesV) {
        //TArista min = new TArista("","",Double.MAX_VALUE);
        TArista min = null;
        
        for(TVertice u : VerticesU) {
            for(TVertice v : VerticesV) {
                TArista primerArista = buscar(u.getEtiqueta(), v.getEtiqueta());
                TArista unoSobrePrimerArista = buscar(v.getEtiqueta(), u.getEtiqueta());
                TArista a = aristaMasLiviana(unoSobrePrimerArista, primerArista);
                
                if(a != null) {
                    if(min == null){
                        min = a;
                    } else if(min.getCosto() > a.getCosto()){
                        min = a;
                    }
                }
            }   
        }    
        return min;
        
        //TODO: ---------COMPLETAR ALGORITMO--------
        // para todo u en Vertices U
        // para todo v en Vertices V
        // tA =buscar (u, v)
        // si tA <> null y tA.costo < costoMin entonces
        // tAMin = tA y costoMin = tA.costo
        // fin para todo v
        // fin para todo u
        // devolver tAMin
        
    }
    
    private TArista aristaMasLiviana(TArista aristaUno, TArista aristaDos){
        //Si una de ellas es null
        if(aristaUno == null){
            return aristaDos;
        }
        else{
            if(aristaDos == null){
                return aristaUno;
            } else{
                if(aristaUno.getCosto() <= aristaDos.getCosto()){
                    return aristaUno;
                } else{
                    return aristaDos;
                }
            }
        }
    }
    
    public TArista Buscarmenor(){
        Collection<TArista> auxA = this.getAristas();
        TArista menor = null;
        for(TArista a : auxA)
        {
            if(menor == null){
                menor = a;
            }
            if(a.costo < menor.costo){
                menor = a;
            } 
        }
        return menor;
    }
    

    public String imprimirEtiquetas() {
        if (getAristas().isEmpty()) {
            return null;
        }
        StringBuilder salida = new StringBuilder();
        //TODO: Completar codigo que imprime todas las aristas de la lista en el siguiente formato:
        //ORIGEN - DESTINO - COSTO
        return salida.toString();

    }

    /**
     * Inserta la arista al final de la coleccion de aristas
     * @param tArista 
     */
    public void insertarAlFinal(TArista tArista) {
        throw new UnsupportedOperationException("Not supported yet.");
    }

    /**
     * @return the aristas
     */
    public Collection<TArista> getAristas() {
        return aristas;
    }

    /**
     * @param aristas the aristas to set
     */
    public void setAristas(Collection<TArista> aristas) {
        this.aristas = aristas;
    }
    
    public TAristas copiar(){
        TAristas aristasCopiadas = new TAristas();
        aristasCopiadas.aristas.addAll(this.aristas);
        
        return aristasCopiadas;
        
    }

}
