package Clases;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;
import UCUGrafos.*;
import java.util.Collection;
import java.util.LinkedList;

/**
 * No, no me equivoqué. Es Ala porque es una sola ?)
 * @author Lithium582
 */
public class AlaUCU {
    
    // <editor-fold defaultstate="extended" desc="Atributos">
    private static AlaUCU _instancia;
    private IGrafoDirigido _grafo;
    private LinkedList<Aerolinea> _aerolineas;
    // </editor-fold>
    
    // <editor-fold defaultstate="extended" desc="Atributos">
    private AlaUCU(){
        this._grafo = new TGrafoDirigido();
        this._aerolineas = new LinkedList();
    }
    // </editor-fold>
    
    /**
     * Retorna la única instancia creada a partir de esta clase
     * @return Instancia de la clase AlaUCU
     */
    public static AlaUCU getInstancia(){
        if(_instancia == null){
            _instancia = new AlaUCU();
        }
        
        return _instancia;
    }
    
    /**
     * Retorna todas las aerolíneas creadas
     * @return Lista con las aerolíneas registradas
     */
    public LinkedList<Aerolinea> getAerolineas(){
        return _aerolineas;
    }
    
    /**
     * Retorna el grafo usado para el sistema
     * @return Grafo Dirigido con la información de aeropuertos y vuelos
     */
    public IGrafoDirigido getGrafo(){
        return this._grafo;
    }
    
    /**
     * Retorna la aerolínea buscando por el código recibido por parámetro o null
     * si no la encuentra
     * @param pCodigo Código de la aerolínea buscada
     * @return Aerolínea con el código recibido por parámetro
     */
    public Aerolinea buscarAerolinea(Comparable<String> pCodigo){
        for(Aerolinea aeroObjeto : this._aerolineas){
            if(aeroObjeto.getID().equals(pCodigo)){
                return aeroObjeto;
            }
        }
        
        return null;
    }
    
    /**
     * Inserta una nueva aerolínea y retorna un booleano confirmando la inserción
     * @param pObjAerolinea Aerolínea que se quiere insertar en la colección
     * @return Valor booleano confirmando la inserción
     */
    public boolean nuevaAerolinea(Aerolinea pObjAerolinea){
        if(buscarAerolinea(pObjAerolinea.getID()) != null){
            return false;
        } else {
            this._aerolineas.add(pObjAerolinea);
            
            return true;
        }
    }
    
    /**
     * Inserta un nuevo aeropuerto y retorna un booleano confirmando la inserción
     * @param pObjAeropuerto Aeropuerto que se quiere insertar en la colección
     * @return Valor booleano confirmando la inserción
     */
    public boolean nuevoAeropuerto(Aeropuerto pObjAeropuerto){
        if(this.buscarAeropuerto(pObjAeropuerto.getID()) != null){
            return false;
        } else {
            this._grafo.insertarVertice(new TVertice(pObjAeropuerto,pObjAeropuerto.getID()));
            
            return true;
        }
    }
    
    /**
     * Inserta una nueva arista y retorna un booleano confirmando la inserción
     * @param pObjArista Arista que se quiere insertar en la colección
     * @return Valor booleano confirmando la inserción
     */
    public boolean nuevaArista(IArista pObjArista){
        return this._grafo.insertarArista(pObjArista);
    }
    
    /**
     * Retorna una lista con todos los vuelos directos existentes entre dos aeropuertos
     * @param pAeropuertoOrigen Código del aeropuerto de origen
     * @param pAeropuertoDestino Código del aeropuerto destino
     * @return Lista con todos los vuelos directos existentes
     */
    public LinkedList<IVuelo> buscarVuelos(Comparable<String> pAeropuertoOrigen, Comparable<String> pAeropuertoDestino){
        IVertice aeropuertoBuscado = this._grafo.buscarVertice(pAeropuertoOrigen);
        IAdyacencia objAdyacente = null;
        
        if(aeropuertoBuscado != null){
            objAdyacente = aeropuertoBuscado.buscarAdyacencia(pAeropuertoDestino);
        }
        
        if(objAdyacente != null){
            LinkedList<IVuelo> listaRetorno = objAdyacente.getRelaciones();
            return listaRetorno;
        }
        
        return null;
    }
    
    /**
     * Busca un aeropuerto por código según lo recibido por parámetro
     * @param pCodigo Código del aeropuerto que se está buscando
     * @return Aeropuerto encontrado o null si no se encuentra
     */
    public Aeropuerto buscarAeropuerto(Comparable pCodigo){
        IVertice objVertice = this._grafo.buscarVertice(pCodigo);
        if(objVertice != null){
            return objVertice.getDatos();
        }
        return null;
    }
    
    /**
     * Elimina un aeropuerto de la colección
     * @param pCodigo Código del aeropuerto que se pretende elminar
     * @return Booleano confirmando la eliminación
     */
    public boolean eliminarAeropuerto(Comparable pCodigo){
        boolean aeroEliminado = this._grafo.eliminarVertice(pCodigo);
        return aeroEliminado;
    }
    
    /**
     * Método auxiliar que, dada una string con formato de fecha, la convierte
     * en un dato de tipo Date.
     *
     * @param pFecha Fecha a castear.
     * @return Fecha en formato Date.
    *
     */
    private Date FormatoFecha(String pFecha) throws ParseException {
        try {
            SimpleDateFormat dt = new SimpleDateFormat("yyyy-MM-dd hh:mm:ss");
            Date date = dt.parse(pFecha);
            return date;
        } catch (ParseException e) {
            throw e;
            //System.err.println("Error de parsing: " + e.getMessage());
        }
    }

    /**
     * Método auxiliar que, dada una string con formato de fecha, la convierte
     * en un dato de tipo Date.
     *
     * @param pFecha Fecha a castear.
     * @return Fecha en formato Date.
    *
     */
    private String RemoverCaracteres(String pCadena) {
        String caracteresRaros = "áàäéèëíìïóòöúùuñÁÀÄÉÈËÍÌÏÓÒÖÚÙÜÑçÇ";
        String caracteresOriginales = "aaaeeeiiiooouuunAAAEEEIIIOOOUUUNcC";

        String strRetorno = pCadena;
        for (int i = 0; i < caracteresRaros.length(); i++) {
            // Reemplazamos los caracteres especiales.
            strRetorno = strRetorno.replace(caracteresRaros.charAt(i), caracteresOriginales.charAt(i));
        }
        return strRetorno;
    }
    
    /**
     * Metodo que nos permite cargar el grafo a partir de tres archivos: Uno
     * conteniendo los aeropuertos en formato "ID,Nombre". Otro con los vuelos
     * en formato "Aerolinea,Origen,Destino,Costo". Y finalmente, uno con las
     * aerolineas con formato "ID,Nombre".
     *
     * @param pArchivoAeropuertos Nombre del archivo de aeropuertos
     * @param pArchivoVuelos Nombre del archivo de vuelos
     * @param pArchivoAerolineas Nombre del archivo de aerolíneas
     */
    public boolean cargarGrafo(String pArchivoAeropuertos, String pArchivoAerolineas, String pArchivoVuelos) {
        //Leemos los archivos, obteniendo así todos los vértices y aristas.
        String[] arrayAeropuertos = ManejadorArchivosGenerico.leerArchivo(pArchivoAeropuertos, false);
        String[] arrayVuelos = ManejadorArchivosGenerico.leerArchivo(pArchivoVuelos, false);
        String[] aeroArray = ManejadorArchivosGenerico.leerArchivo(pArchivoAerolineas, false);
        boolean resultado = false;

        Collection<IVertice> losVertices = new LinkedList<IVertice>();
        Collection<IArista> lasAristas = new LinkedList<IArista>();

        resultado = aeroArray.length > 0;
        for (String actual : aeroArray) {
            String[] lineaArchivo = actual.split(",");
            if (lineaArchivo[0].trim().length() == 2) {
                Aerolinea aeroLinea = new Aerolinea(lineaArchivo[0].trim(), lineaArchivo[1].trim());
                this.nuevaAerolinea(aeroLinea);
            }
        }

        resultado = resultado || arrayAeropuertos.length > 0;
        //Cargamos los vertices en el grafo
        for (String actual : arrayAeropuertos) {
            String[] lineaArchivo = actual.split(",");
            if ((lineaArchivo[0].trim().length() == 3)) {
                String ID = (lineaArchivo[0].trim());
                String name = lineaArchivo[1].trim();
                //Creamos el aeropuerto a partir de la info obtenida
                Aeropuerto nuevoAeropuerto = new Aeropuerto(ID, name);
                //Lo insertamos en la coleccion
                losVertices.add(new TVertice(nuevoAeropuerto, ID));
            }
        }

        resultado = resultado || arrayVuelos.length > 0;
        //Cargamos las aristas en el grafo
        for (String actual : arrayVuelos) {
            String[] line = actual.split(",");
            if ((line[0].trim().length() == 2) && (line[1].trim().length() == 3)
                    && (line[2].trim().length() == 3)) {
                Comparable<String> aerolinea = line[0].trim();
                Comparable<String> origen = line[1].trim();
                
                String destino = line[2].trim();
                double costo = Double.parseDouble(line[3].trim());
                //Creamos un vuelo a partir de la informacion
                IVuelo nuevoVuelo = new Vuelo(origen, destino,costo, aerolinea);
                //TArista(Comparable etiquetaOrigen, Comparable etiquetaDestino, LinkedList<E> pRelaciones)
                TArista nuevaArista = new TArista(origen, destino, nuevoVuelo);
                lasAristas.add(nuevaArista);
            }
        }
        
        this._grafo.cargarGrafo(losVertices, lasAristas);
        
        return resultado;
    }
    
    
    /**
     * Método que retorna una instancia de la clase TCaminos conteniendo todos los caminos posibles entre
     * dos aeropuertos, así como una instancia de la clase TCamino que tiene el camino de menor costo ingresado
     * @param pEtiquetaOrigen Aeropuerto desde el que se desea partir
     * @param pEtiquetaDestino Aeropuerto al que se desea llegar
     * @param pCantidadEscalas Cantidad de escalas máxima
     * @param pAerolinea Aerolínea en la que se desea viajar
     * @return Instancia de TCaminos con todos los caminos posibles
     */
    public TCaminos todosLosCaminos(Comparable pEtiquetaOrigen, Comparable pEtiquetaDestino, int pCantidadEscalas, Comparable pAerolinea){
        return this._grafo.todosLosCaminos(pEtiquetaOrigen, pEtiquetaDestino,pCantidadEscalas,pAerolinea);
    }
    
    /**
     * Retorna la posición en el hashMap de una clave o -1 si no se encuentra
     * @param pComp Código que se está buscando en el hashMap
     * @return Posición de la clave en el hash o -1 si no se encuentra en ella
     */
    public int obtenerPosicionEnElHashMap(Comparable pComp){
        return this._grafo.obtenerPosicionEnElHashMap(pComp);
    }
    
    /**
     * Retorna la clave para una posición determinada en el hashMap
     * @param pPosicion Posición buscada en el hashMap
     * @return La clave que se encuentra en la posición o cero si no existe
     */
    public Comparable obtenerEtiquetaPorPosicion(int pPosicion){
        return this._grafo.obtenerEtiquetaPorPosicion(pPosicion);
    }
}
